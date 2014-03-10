module.exports = {
	Promise : function(cb) {
		"use strict";

		var self = this,
			_enumStates = ["pending", "fulfilled", "rejected"],
			_state = 0,
			_value = null,
			_reason = ''
			_onFulfilled = [],
			_onRejected = [];

		this.getState = function() {
			return self._enumStates[self._state];
		}

		this.then = function(onFulfilled, onRejected) {
			if ('function' == typeof onFulfilled) {
				_onFulfilled.push(onFulfilled);
			}

			if ('function' == typeof onRejected) {
				_onRejected.push(onRejected);
			}

			return self;
		}

		this.reject = function(reason) {
			if (0 != self._state) {
				throw new Exception('Cannot reject a resolved Promise');
			}
			_state = 2;
			_onRejected.forEach(function(onRejected) {
				onRejected(reason);
			});
			_onRejected = [];
		}

		this.fulfil = function(value) {
			if (0 != self._state) {
				throw new Exception('Cannot fulfil a resolved Promise');
			}
			_state = 1;
			_onFulfilled.forEach(function(onFulfilled) {
				onFulfilled(value);
			});
			_onRejected = [];
		}

		_onFulfilled.push(cb)
	}
};
