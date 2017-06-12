import { Injectable } from '@angular/core';
import { NgRedux } from '@angular-redux/store';
import { createAction } from 'redux-actions';
import { IAppState, IHitlistData, IHitlistRetrieveInfo } from '../store';

@Injectable()
export class RegistrySearchActions {
  static SEARCH_RECORDS = 'SEARCH_RECORDS';
  static SEARCH_RECORDS_SUCCESS = 'SEARCH_RECORDS_SUCCESS';
  static SEARCH_RECORDS_ERROR = 'SEARCH_RECORDS_ERROR';
  static RETRIEVE_HITLIST = 'RETRIEVE_HITLIST';
  static RETRIEVE_HITLIST_SUCCESS = 'RETRIEVE_HITLIST_SUCCESS';
  static RETRIEVE_HITLIST_ERROR = 'RETRIEVE_HITLIST_ERROR';
  static RETRIEVE_QUERY_FORM = 'RETRIEVE_QUERY_FORM';
  static RETRIEVE_QUERY_FORM_SUCCESS = 'RETRIEVE_QUERY_FORM_SUCCESS';
  static RETRIEVE_QUERY_FORM_ERROR = 'RETRIEVE_QUERY_FORM_ERROR';
  static OPEN_HITLISTS = 'OPEN_HITLISTS';
  static OPEN_HITLISTS_SUCCESS = 'OPEN_HITLISTS_SUCCESS';
  static OPEN_HITLISTS_ERROR = 'OPEN_HITLISTS_ERROR';
  static DELETE_HITLIST = 'DELETE_HITLIST';
  static DELETE_HITLIST_ERROR = 'DELETE_HITLIST_ERROR';
  static UPDATE_HITLIST = 'UPDATE_HITLIST';
  static UPDATE_HITLIST_ERROR = 'UPDATE_HITLIST_ERROR';
  static SAVE_HITLISTS = 'SAVE_HITLISTS';
  static SAVE_HITLISTS_ERROR = 'SAVE_HITLISTS_ERROR';
  static openHitlistsAction = createAction(RegistrySearchActions.OPEN_HITLISTS);
  static openHitlistsSuccessAction = createAction(RegistrySearchActions.OPEN_HITLISTS_SUCCESS);
  static openHitlistsErrorAction = createAction(RegistrySearchActions.OPEN_HITLISTS_ERROR);
  static updateHitlistAction = createAction(RegistrySearchActions.UPDATE_HITLIST,
    (hitlistData: IHitlistData) => (hitlistData));
  static updateHitlistErrorAction = createAction(RegistrySearchActions.UPDATE_HITLIST_ERROR);
  static deleteHitlistAction = createAction(RegistrySearchActions.DELETE_HITLIST,
    (id: number) => ({ id }));
  static deleteHitlistErrorAction = createAction(RegistrySearchActions.DELETE_HITLIST_ERROR);
  static searchRecordsAction = createAction(RegistrySearchActions.SEARCH_RECORDS,
    (temporary: boolean, searchCriteria: string) => ({ temporary, searchCriteria }));
  static searchRecordsSuccessAction = createAction(RegistrySearchActions.SEARCH_RECORDS_SUCCESS,
    (temporary: boolean, rows: any[]) => ({ temporary, rows }));
  static searchRecordsErrorAction = createAction(RegistrySearchActions.SEARCH_RECORDS_ERROR);
  static retrieveHitlistAction = createAction(RegistrySearchActions.RETRIEVE_HITLIST,
    (hitlistRetrieveInfo: IHitlistRetrieveInfo) => (hitlistRetrieveInfo));
  static retrieveHitlistSuccessAction = createAction(RegistrySearchActions.RETRIEVE_HITLIST_SUCCESS);
  static retrieveHitlistErrorAction = createAction(RegistrySearchActions.RETRIEVE_HITLIST_ERROR);
  static retrieveQueryFormAction = createAction(RegistrySearchActions.RETRIEVE_QUERY_FORM,
    (temporary: boolean, id: number) => ({ temporary, id }));
  static retrieveQueryFormSuccessAction = createAction(RegistrySearchActions.RETRIEVE_QUERY_FORM_SUCCESS);
  static retrieveQueryFormErrorAction = createAction(RegistrySearchActions.RETRIEVE_QUERY_FORM_ERROR);

  constructor(private ngRedux: NgRedux<IAppState>) { }

  searchRecords(temporary: boolean, searchCriteria: string) {
    this.ngRedux.dispatch(RegistrySearchActions.searchRecordsAction(temporary, searchCriteria));
  }

  searchRecordsSuccess(temporary: boolean, rows: any[]) {
    this.ngRedux.dispatch(RegistrySearchActions.searchRecordsSuccessAction(temporary, rows));
  }

  searchRecordsError() {
    this.ngRedux.dispatch(RegistrySearchActions.searchRecordsErrorAction());
  }

  retrieveQueryForm(temporary: boolean, id: number) {
    this.ngRedux.dispatch(RegistrySearchActions.retrieveQueryFormAction(temporary, id));
  }

  retrieveQueryFormSuccess(data: any[]) {
    this.ngRedux.dispatch(RegistrySearchActions.retrieveQueryFormSuccessAction(data));
  }

  retrieveQueryFormError() {
    this.ngRedux.dispatch(RegistrySearchActions.retrieveQueryFormErrorAction());
  }

  openHitlists() {
    this.ngRedux.dispatch(RegistrySearchActions.openHitlistsAction());
  }

  deleteHitlist(id: number) {
    this.ngRedux.dispatch(RegistrySearchActions.deleteHitlistAction(id));
  }

  updateHitlist(data: IHitlistData) {
    this.ngRedux.dispatch(RegistrySearchActions.updateHitlistAction(data));
  };

  retrieveHitlist(data: IHitlistRetrieveInfo) {
    this.ngRedux.dispatch(RegistrySearchActions.retrieveHitlistAction(data));
  };
}
