import { Component, ElementRef, ViewChildren, OnInit, Injector } from '@angular/core';
import DevExtreme from 'devextreme/bundles/dx.all.d';
import CustomStore from 'devextreme/data/custom_store';
import { DxDataGridComponent, DxFormComponent } from 'devextreme-angular';
import { HttpService } from '../../services';
import { getExceptionMessage, notifyError, notifySuccess } from '../../common';
import { ILookupData } from '../../redux';
import { apiUrlPrefix } from '../../configuration';
import { CConfigAddIn } from './config.types';
import { RegConfigBaseComponent } from './config-base';

@Component({
  selector: 'reg-config-addins',
  template: require('./config-addins.component.html'),
  styles: [require('./config.component.css'), require('../registry/records.css')],
  host: { '(document:click)': 'onDocumentClick($event)' }
})
export class RegConfigAddins extends RegConfigBaseComponent implements OnInit {
  @ViewChildren(DxDataGridComponent) grids;
  @ViewChildren(DxFormComponent) forms;
  private rows: any[] = [];
  private dataSource: CustomStore;
  private configAddIn: CConfigAddIn;

  constructor(elementRef: ElementRef, http: HttpService) {
    super(elementRef, http);
  }

  loadData(lookups: ILookupData) {
    this.configAddIn = new CConfigAddIn(lookups);
    this.dataSource = this.createCustomStore();
    this.gridHeight = this.getGridHeight();
  }

  onEditingStart(e) {
    e.cancel = true;
    this.configAddIn.addEditProperty('edit', e);
  }

  onInitNewRow(e) {
    this.configAddIn.addEditProperty('add', e);
    e.component.cancelEditData();
    e.component.refresh();
  }

  onFieldDataChanged(e) {
    if (e.dataField === 'className' && e.value) {
      this.configAddIn.editRow.events = [];
      this.configAddIn.columns.editColumn.events[1].lookup = {};
      this.configAddIn.currentEvents = this.configAddIn.addinAssemblies[0].classes.filter
        (s => s.name === e.value);
      this.configAddIn.columns.editColumn.events[1].lookup = {
        dataSource: this.configAddIn.currentEvents[0].eventHandlers, valueExpr: 'name', displayExpr: 'name'
      };
      this.grids.last.instance.refresh();
    }
  }

  save(e) {
    switch (this.configAddIn.window.viewIndex) {
      case 'edit':
        this.dataSource.update(this.configAddIn.editRow, []).done(result => {
          this.cancel();
        }).fail(err => {
          notifyError(err, 5000);
        });
        break;
      case 'add':
        if (this.forms._results[0].instance.validate().isValid) {
          this.dataSource.insert(this.configAddIn.editRow).done(result => {
            this.cancel();
          }).fail(err => {
            notifyError(err, 5000);
          });
        }
        break;
    }
  }

  cancel() {
    this.grids.first.instance.cancelEditData();
    this.grids.first.instance.refresh();
    this.configAddIn.window = { title: 'Manage Addins', viewIndex: 'list' };
  }

  private createCustomStore(): CustomStore {
    let tableName = 'addins';
    let apiUrlBase = `${apiUrlPrefix}${tableName}`;
    return new CustomStore({
      load: ((loadOptions: DevExtreme.data.LoadOptions): Promise<any> => {
        return new Promise<void>((resolve, reject) => {
          this.http.get(apiUrlBase)
            .toPromise()
            .then(result => {
              let rows = result.json();
              resolve(rows);
            })
            .catch(error => {
              let message = getExceptionMessage(`The records of ${tableName} were not retrieved properly due to a problem`, error);
              reject(message);
            });
        });
      }).bind(this),

      update: ((key, values): Promise<any> => {
        let data = key;
        let newData = values;
        for (let k in newData) {
          if (newData.hasOwnProperty(k)) {
            data[k] = newData[k];
          }
        }
        let id = data[Object.getOwnPropertyNames(data)[0]];
        return new Promise<any>((resolve, reject) => {
          this.http.put(`${apiUrlBase}`, data)
            .toPromise()
            .then(result => {
              notifySuccess(`The record ${id} of ${tableName} was updated successfully!`, 5000);
              resolve(result.json());
            })
            .catch(error => {
              let message = getExceptionMessage(`The record ${id} of ${tableName} was not updated due to a problem`, error);
              reject(message);
            });
        });
      }).bind(this),

      insert: ((values): Promise<any> => {
        return new Promise<any>((resolve, reject) => {
          this.http.post(`${apiUrlBase}`, values)
            .toPromise()
            .then(result => {
              let id = result.json().id;
              notifySuccess(`A new record ${id} of ${tableName} was created successfully!`, 5000);
              resolve(result.json());
            })
            .catch(error => {
              let message = getExceptionMessage(`Creating a new record for ${tableName} failed due to a problem`, error);
              reject(message);
            });
        });
      }).bind(this),

      remove: ((key): Promise<any> => {
        let id = key[Object.getOwnPropertyNames(key)[0]];
        return new Promise<any>((resolve, reject) => {
          this.http.delete(`${apiUrlBase}/${id}`)
            .toPromise()
            .then(result => {
              notifySuccess(`The record ${id} of ${tableName} was deleted successfully!`, 5000);
              resolve(result.json());
            })
            .catch(error => {
              let message = getExceptionMessage(`The record ${id} of ${tableName} was not deleted due to a problem`, error);
              reject(message);
            });
        });
      }).bind(this)
    });
  }
};
