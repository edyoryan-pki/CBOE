import {
  Component, Input, Output, EventEmitter, ElementRef, ViewChild,
  OnInit, OnDestroy, ChangeDetectionStrategy, ChangeDetectorRef
} from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { select, NgRedux } from '@angular-redux/store';
import { DxDataGridComponent } from 'devextreme-angular';
import CustomStore from 'devextreme/data/custom_store';
import { Observable } from 'rxjs/Observable';
import { Subscription } from 'rxjs/Subscription';
import { ConfigurationActions } from '../../actions/configuration.actions';
import { getExceptionMessage, notify, notifyError, notifySuccess } from '../../common';
import { apiUrlPrefix } from '../../configuration';
import { IAppState, ICustomTableData, IConfiguration, ILookupData } from '../../store';
import { CConfigTable } from './config.types';
import { HttpService } from '../../services';
import privileges from '../../common/utils/privilege.utils';

declare var jQuery: any;

@Component({
  selector: 'reg-config-tables',
  template: require('./config-tables.component.html'),
  styles: [require('./config.component.css')],
  host: { '(document:click)': 'onDocumentClick($event)' },
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class RegConfigTables implements OnInit, OnDestroy {
  @ViewChild(DxDataGridComponent) grid: DxDataGridComponent;
  @select(s => s.configuration.customTables) customTables$: Observable<any>;
  @select(s => s.session.lookups) lookups$: Observable<ILookupData>;
  private lookupsSubscription: Subscription;
  private lookups: ILookupData;
  private tableId: string;
  private rows: any[] = [];
  private tableIdSubscription: Subscription;
  private dataSubscription: Subscription;
  private gridHeight: string;
  private dataSource: CustomStore;
  private configTable: CConfigTable;

  constructor(
    private route: ActivatedRoute,
    private http: HttpService,
    private changeDetector: ChangeDetectorRef,
    private ngRedux: NgRedux<IAppState>,
    private configurationActions: ConfigurationActions,
    private elementRef: ElementRef
  ) { }

  ngOnInit() {
    this.tableIdSubscription = this.route.params.subscribe(params => {
      let paramLabel = 'tableId';
      this.tableId = params[paramLabel];
      this.configurationActions.openTable(this.tableId);
      this.configTable = new CConfigTable(this.tableId, this.ngRedux.getState());
    });
    this.dataSubscription = this.customTables$.subscribe((customTables: any) => this.loadData(customTables));
    this.lookupsSubscription = this.lookups$.subscribe(d => { if (d) { this.retrieveLookUpData(d); } });
  }

  ngOnDestroy() {
    if (this.tableIdSubscription) {
      this.tableIdSubscription.unsubscribe();
    }
    if (this.dataSubscription) {
      this.dataSubscription.unsubscribe();
    }
  }

  loadData(customTables: any) {
    if (customTables && customTables[this.tableId]) {
      let customTableData: ICustomTableData = customTables[this.tableId];
      this.rows = customTableData.rows;
      this.dataSource = this.createCustomStore(this);
      this.changeDetector.markForCheck();
    }
    this.gridHeight = this.getGridHeight();
  }

  private retrieveLookUpData(lookups: ILookupData) {
    this.lookups = lookups;
  }

  private getGridHeight() {
    return ((this.elementRef.nativeElement.parentElement.clientHeight) - 100).toString();
  }

  private onResize(event: any) {
    this.gridHeight = this.getGridHeight();
    this.grid.height = this.getGridHeight();
    this.grid.instance.repaint();
  }

  private onDocumentClick(event: any) {
    if (event.srcElement.title === 'Full Screen') {
      let fullScreenMode = event.srcElement.className === 'fa fa-compress fa-stack-1x white';
      this.gridHeight = (this.elementRef.nativeElement.parentElement.clientHeight - (fullScreenMode ? 10 : 190)).toString();
      this.grid.height = this.gridHeight;
      this.grid.instance.repaint();
    }
  }

  onContentReady(e) {
    e.component.columnOption('STRUCTURE', {
      width: 150,
      allowFiltering: false,
      allowSorting: false,
      cellTemplate: 'cellTemplate'
    });
    e.component.columnOption('command:edit', {
      visibleIndex: -1,
      width: 80
    });
    e.component.columnOption('command', {
      visibleIndex: -1,
      width: 80
    });
  }

  onCellPrepared(e) {
    if (e.rowType === 'data' && e.column.command === 'edit') {
      let isEditing = e.row.isEditing;
      let $links = e.cellElement.find('.dx-link');
      $links.text('');
      if (isEditing) {
        $links.filter('.dx-link-save').addClass('dx-icon-save');
        $links.filter('.dx-link-cancel').addClass('dx-icon-revert');
      } else {
        if (this.hasPrivilege('EDIT')) {
          $links.filter('.dx-link-edit').addClass('dx-icon-edit');
        }
        if (this.hasPrivilege('DELETE')) {
          $links.filter('.dx-link-delete').addClass('dx-icon-trash');
        }
      }
    }
  }

  private hasPrivilege(action: string): boolean {
    let retValue: boolean = false;
    switch (this.tableId) {
      case 'VW_PROJECT':
        retValue = privileges.hasProjectsTablePrivilege(action, this.lookups.userPrivileges);
        break;
      case 'VW_NOTEBOOKS':
        retValue = privileges.hasNotebookTablePrivilege(action, this.lookups.userPrivileges);
        break;
      case 'VW_FRAGMENT':
        retValue = privileges.hasSaltTablePrivilege(action, this.lookups.userPrivileges);
        break;
      case 'VW_SEQUENCE':
        retValue = privileges.hasSequenceTablePrivilege(action, this.lookups.userPrivileges);
        break;
      case 'VW_PICKLIST':
      case 'VW_PICKLISTDOMAIN':
      case 'VW_FRAGMENTTYPE':
      case 'VW_IDENTIFIERTYPE':
      case 'VW_SITES':
        retValue = true;
        break;
    }
    return retValue;
  }

  tableName() {
    let tableName = this.tableId;
    tableName = tableName.toLowerCase()
      .replace('vw_', '').replace('domain', ' domain').replace('type', ' type');
    if (!tableName.endsWith('s')) {
      tableName += 's';
    }
    return tableName.split(' ').map(n => n.charAt(0).toUpperCase() + n.slice(1)).join(' ');
  }

  private createCustomStore(parent: RegConfigTables): CustomStore {
    let tableName = parent.tableId;
    let apiUrlBase = `${apiUrlPrefix}custom-tables/${tableName}`;
    return new CustomStore({
      load: function (loadOptions) {
        let deferred = jQuery.Deferred();
        parent.http.get(apiUrlBase)
          .toPromise()
          .then(result => {
            let rows = result.json().rows;
            deferred.resolve(rows, { totalCount: rows.length });
          })
          .catch(error => {
            let message = getExceptionMessage(`The records of ${tableName} were not retrieved properly due to a problem`, error);
            deferred.reject(message);
          });
        return deferred.promise();
      },

      update: function (key, values) {
        let deferred = jQuery.Deferred();
        let data = key;
        let newData = values;
        for (let k in newData) {
          if (newData.hasOwnProperty(k)) {
            data[k] = newData[k];
          }
        }
        let id = data[Object.getOwnPropertyNames(data)[0]];
        parent.http.put(`${apiUrlBase}/${id}`, data)
          .toPromise()
          .then(result => {
            notifySuccess(`The record ${id} of ${tableName} was updated successfully!`, 5000);
            deferred.resolve(result.json());
          })
          .catch(error => {
            let message = getExceptionMessage(`The record ${id} of ${tableName} was not updated due to a problem`, error);
            deferred.reject(message);
          });
        return deferred.promise();
      },

      insert: function (values) {
        let deferred = jQuery.Deferred();
        parent.http.post(`${apiUrlBase}`, values)
          .toPromise()
          .then(result => {
            let id = result.json().id;
            notifySuccess(`A new record ${id} of ${tableName} was created successfully!`, 5000);
            deferred.resolve(result.json());
          })
          .catch(error => {
            let message = getExceptionMessage(`Creating a new record for ${tableName} failed due to a problem`, error);
            deferred.reject(message);
          });
        return deferred.promise();
      },

      remove: function (key) {
        let deferred = jQuery.Deferred();
        let id = key[Object.getOwnPropertyNames(key)[0]];
        parent.http.delete(`${apiUrlBase}/${id}`)
          .toPromise()
          .then(result => {
            notifySuccess(`The record ${id} of ${tableName} was deleted successfully!`, 5000);
            deferred.resolve(result.json());
          })
          .catch(error => {
            let message = getExceptionMessage(`The record ${id} of ${tableName} was not deleted due to a problem`, error);
            deferred.reject(message);
          });
        return deferred.promise();
      }
    });
  }
  editLookupValueChanged(e, d) {
    d.setValue(e.value, d.column.dataField);
  }
};
