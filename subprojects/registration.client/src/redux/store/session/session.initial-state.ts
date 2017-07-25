import {
  ISessionRecord,
  ISession,
  IUser,
  IUserRecord,
} from './session.types';
import { makeTypedFactory } from 'typed-immutable-record';


export const UserFactory = makeTypedFactory<IUser, IUserRecord>({
  fullName: null
});

export const INITIAL_USER_STATE = UserFactory();

export const SessionFactory = makeTypedFactory<ISession, ISessionRecord>({
  token: null,
  user: INITIAL_USER_STATE,
  hasError: false,
  isLoading: false,
  lookups: null,
});

export const INITIAL_SESSION_STATE = SessionFactory();