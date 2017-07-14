import { Iterable } from 'immutable';
import { registrySearchReducer } from './registry-search.reducer';
import { RegistrySearchActions } from '../../actions';
import { IRegistrySearchRecord, HitlistType, IHitlistData, IHitlistRetrieveInfo, ISearchRecords, INITIAL_SEARCH_STATE } from './registry-search.types';

describe('registry search reducer', () => {
  let initState: IRegistrySearchRecord;

  beforeEach(() => {
    initState = INITIAL_SEARCH_STATE;
  });

  it('should have an immutable initial state', () => {
    expect(Iterable.isIterable(initState)).toBe(true);
  });

  it('should update hitlist.rows on OPEN_HITLISTS_SUCCESS', () => {
    const rows: IHitlistData[] = [
      { hitlistType: HitlistType.TEMP, name: 'temp1', isPublic: false },
      { hitlistType: HitlistType.TEMP, name: 'temp2', isPublic: false }];
    const nextState = registrySearchReducer(
      initState,
      RegistrySearchActions.openHitlistsSuccessAction(rows)
    );
    expect(nextState.hitlist.rows).toEqual(rows);
  });
});
