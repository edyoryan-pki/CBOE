import { Component, EventEmitter, Input, Output, OnChanges, ChangeDetectionStrategy, ViewEncapsulation } from '@angular/core';
import { CFormGroup, CForm, CCoeForm } from '../../../../common';
import { CViewGroup } from '../registry-base.types';

@Component({
  selector: 'reg-form-group-view',
  template: require('./form-group-view.component.html'),
  styles: [require('../registry-base.css')],
  encapsulation: ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class RegFormGroupView implements OnChanges {
  @Input() id: string;
  @Input() editMode: boolean = false;
  @Input() data: any;
  @Input() formGroupData: CFormGroup;
  private viewGroups: CViewGroup[] = [];

  constructor() {
  }

  ngOnChanges() {
    if (this.formGroupData && this.formGroupData.detailsForms && this.formGroupData.detailsForms.detailsForm.length > 0) {
      let coeForms = this.formGroupData.detailsForms.detailsForm[0].coeForms.coeForm;
      coeForms.forEach(f => {
        if (this.viewGroups.length === 0) {
          this.viewGroups.push(new CViewGroup([]));
        }
        let viewGroup = this.viewGroups[this.viewGroups.length - 1];
        if (!viewGroup.append(f)) {
          this.viewGroups.push(new CViewGroup([ f ]));
        }
      });
    }
  }

  private togglePanel(e) {
    if (e.srcElement.children.length > 0) {
      e.srcElement.children[0].click();
    }
  }
};
