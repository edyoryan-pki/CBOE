import {
  async,
  inject,
  TestBed,
} from '@angular/core/testing';
import { RegNavigatorHeader } from './navigator-header.component';
import { RegNavigatorModule } from './navigator.module';
import { configureTests } from '../../tests.configure';

describe('Component: Navigator Header', () => {
  let fixture;

  beforeEach(done => {
    const configure = (testBed: TestBed) => {
      testBed.configureTestingModule({
        imports: [RegNavigatorModule],
      });
    };

    configureTests(configure).then(testBed => {
      fixture = testBed.createComponent(RegNavigatorHeader);
      fixture.detectChanges();
      done();
    });
  });

  it('should render the navigation header with the correct classes applied',
    async(inject([], () => {
      fixture.whenStable().then(() => {
        let compiled = fixture.debugElement.nativeElement;
        expect(compiled.querySelector('div').getAttribute('class'))
          .toBe('navbar-header');
      });
    })
    ));
});
