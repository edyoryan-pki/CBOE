import { fakeAsync, inject, TestBed, } from '@angular/core/testing';
import { HttpModule, XHRBackend, ResponseOptions, Response } from '@angular/http';
import { MockBackend, MockConnection } from '@angular/http/testing/mock_backend';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/observable/throw';
import { NgRedux, NgReduxModule, DevToolsExtension } from 'ng2-redux';
import { NgReduxRouter } from 'ng2-redux-router';
import { RegistryActions } from '../actions';
import { RegistryEpics } from './registry.epics';
import { configureTests } from '../tests.configure';

describe('configuration.epics', () => {
  beforeEach(done => {
    const configure = (testBed: TestBed) => {
      testBed.configureTestingModule({
        imports: [HttpModule, NgReduxModule.forRoot()],
        providers: [
          NgReduxRouter,
          { provide: XHRBackend, useClass: MockBackend },
          RegistryEpics
        ]
      });
    };
    configureTests(configure).then(done);
  });

  it('should open and retrieve records', fakeAsync(
    inject([XHRBackend, RegistryEpics], (mockBackend, registryEpics) => {
      const temporary: boolean = true;
      const data = [{ id: 1, value: 'v1' }, { id: 2, value: 'v2' }];
      mockBackend.connections.subscribe((connection: MockConnection) => {
        connection.mockRespond(new Response(new ResponseOptions({ body: data })));
      });

      const action$ = Observable.of(RegistryActions.openRecordsAction(temporary));
      registryEpics.handleOpenRecords(action$).subscribe(action =>
        expect(action).toEqual(RegistryActions.openRecordsSuccessAction(temporary, data))
      );
    })
  ));

  it('should process a open-records error', fakeAsync(
    inject([XHRBackend, RegistryEpics], (mockBackend, registryEpics) => {
      const error = new Error('cannot get records');
      mockBackend.connections.subscribe((connection: MockConnection) => {
        connection.mockError(error);
      });

      const action$ = Observable.of(RegistryActions.openRecordsAction(true));
      registryEpics.handleOpenRecords(action$).subscribe(action =>
        expect(action).toEqual(RegistryActions.openRecordsErrorAction(error))
      );
    })
  ));
});
