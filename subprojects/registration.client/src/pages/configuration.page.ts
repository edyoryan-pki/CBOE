import { Component, Inject, ApplicationRef } from '@angular/core';
import { AsyncPipe } from '@angular/common';
import { Observable } from 'rxjs/Observable';
import { select } from '@angular-redux/store';
import { ConfigurationActions } from '../actions';
import { RegContainer, RegConfiguration } from '../components';
import { IConfiguration } from '../store/configuration';

@Component({
  selector: 'configuration-page',
  providers: [ ConfigurationActions ],
  template: `
    <reg-container testid="configuration">
      <reg-configuration
        [configuration]="configuration$ | async"
        (create)="actions.create()"
        (edit)="actions.edit()">
      </reg-configuration>
    </reg-container>
  `
})
export class RegConfigurationPage {
  @select() configuration$: Observable<IConfiguration>;
  constructor(private actions: ConfigurationActions) {}
}
