import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { createLayoutPolicy, getWindowSizeClass, WindowSizeClass } from '../main/ets/common/LayoutPolicy';

export default function localUnitTest() {
  describe('localUnitTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('classifiesWindowWidth', 0, () => {
      expect(getWindowSizeClass(359)).assertEqual(WindowSizeClass.COMPACT);
      expect(getWindowSizeClass(600)).assertEqual(WindowSizeClass.MEDIUM);
      expect(getWindowSizeClass(839)).assertEqual(WindowSizeClass.MEDIUM);
      expect(getWindowSizeClass(840)).assertEqual(WindowSizeClass.EXPANDED);
    });

    it('createsLayoutPolicy', 0, () => {
      const phonePolicy = createLayoutPolicy(360);
      expect(phonePolicy.columns).assertEqual(1);
      expect(phonePolicy.useSideNavigation).assertFalse();

      const tabletPolicy = createLayoutPolicy(720);
      expect(tabletPolicy.columns).assertEqual(2);
      expect(tabletPolicy.useSideNavigation).assertTrue();

      const largePolicy = createLayoutPolicy(1024);
      expect(largePolicy.columns).assertEqual(3);
      expect(largePolicy.useSideNavigation).assertTrue();
    });
  });
}
