import 'package:fake_async/fake_async.dart';
import 'package:flutter_clean_arch_template/core/utils/debouncer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Debouncer', () {
    test('runs callback after configured delay', () {
      fakeAsync((async) {
        final debouncer = Debouncer(milliseconds: 300);
        var called = false;

        debouncer.run(() => called = true);

        async.elapse(const Duration(milliseconds: 299));
        expect(called, isFalse);

        async.elapse(const Duration(milliseconds: 1));
        expect(called, isTrue);
      });
    });

    test('replaces previous pending callback when run is called again', () {
      fakeAsync((async) {
        final debouncer = Debouncer(milliseconds: 300);
        var calls = 0;

        debouncer.run(() => calls++);
        async.elapse(const Duration(milliseconds: 150));
        debouncer.run(() => calls++);

        async.elapse(const Duration(milliseconds: 299));
        expect(calls, 0);

        async.elapse(const Duration(milliseconds: 1));
        expect(calls, 1);
      });
    });

    test('does not run callback after dispose', () {
      fakeAsync((async) {
        final debouncer = Debouncer(milliseconds: 300);
        var called = false;

        debouncer.run(() => called = true);
        debouncer.dispose();

        async.elapse(const Duration(seconds: 1));
        expect(called, isFalse);
      });
    });
  });
}
