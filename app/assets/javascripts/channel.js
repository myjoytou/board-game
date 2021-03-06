/**
 * Created by infibam on 11/10/16.
 */
/*
 The channel object is returned when you subscribe to a channel.
 For instance:
 var dispatcher = new WebSocketRails('localhost:3000/websocket');
 var awesome_channel = dispatcher.subscribe('awesome_channel');
 awesome_channel.bind('event', function(data) { console.log('channel event!'); });
 awesome_channel.trigger('awesome_event', awesome_object);
 If you want to unbind an event, you can use the unbind function :
 awesome_channel.unbind('event')
 */
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

WebSocketRails.Channel = (function() {
    function Channel(_at_name, _at__dispatcher, _at_is_private, _at_on_success, _at_on_failure) {
        var event, event_name, _ref;
        this.name = _at_name;
        this._dispatcher = _at__dispatcher;
        this.is_private = _at_is_private != null ? _at_is_private : false;
        this.on_success = _at_on_success;
        this.on_failure = _at_on_failure;
        this._failure_launcher = __bind(this._failure_launcher, this);
        this._success_launcher = __bind(this._success_launcher, this);
        this._callbacks = {};
        this._token = void 0;
        this._queue = [];
        if (this.is_private) {
            event_name = 'websocket_rails.subscribe_private';
        } else {
            event_name = 'websocket_rails.subscribe';
        }
        this.connection_id = (_ref = this._dispatcher._conn) != null ? _ref.connection_id : void 0;
        event = new WebSocketRails.Event([
            event_name, {
                data: {
                    channel: this.name
                }
            }, this.connection_id
        ], this._success_launcher, this._failure_launcher);
        this._dispatcher.trigger_event(event);
    }

    Channel.prototype.destroy = function() {
        var event, event_name, _ref;
        if (this.connection_id === ((_ref = this._dispatcher._conn) != null ? _ref.connection_id : void 0)) {
            event_name = 'websocket_rails.unsubscribe';
            event = new WebSocketRails.Event([
                event_name, {
                    data: {
                        channel: this.name
                    }
                }, this.connection_id
            ]);
            this._dispatcher.trigger_event(event);
        }
        return this._callbacks = {};
    };

    Channel.prototype.bind = function(event_name, callback) {
        var _base;
        if ((_base = this._callbacks)[event_name] == null) {
            _base[event_name] = [];
        }
        return this._callbacks[event_name].push(callback);
    };

    Channel.prototype.unbind = function(event_name) {
        return delete this._callbacks[event_name];
    };

    Channel.prototype.trigger = function(event_name, message) {
        var event;
        event = new WebSocketRails.Event([
            event_name, {
                channel: this.name,
                data: message,
                token: this._token
            }, this.connection_id
        ]);
        if (!this._token) {
            return this._queue.push(event);
        } else {
            return this._dispatcher.trigger_event(event);
        }
    };

    Channel.prototype.dispatch = function(event_name, message) {
        var callback, _i, _len, _ref, _ref1, _results;
        if (event_name === 'websocket_rails.channel_token') {
            this.connection_id = (_ref = this._dispatcher._conn) != null ? _ref.connection_id : void 0;
            this._token = message['token'];
            return this.flush_queue();
        } else {
            if (this._callbacks[event_name] == null) {
                return;
            }
            _ref1 = this._callbacks[event_name];
            _results = [];
            for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
                callback = _ref1[_i];
                _results.push(callback(message));
            }
            return _results;
        }
    };

    Channel.prototype._success_launcher = function(data) {
        if (this.on_success != null) {
            return this.on_success(data);
        }
    };

    Channel.prototype._failure_launcher = function(data) {
        if (this.on_failure != null) {
            return this.on_failure(data);
        }
    };

    Channel.prototype.flush_queue = function() {
        var event, _i, _len, _ref;
        _ref = this._queue;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            event = _ref[_i];
            this._dispatcher.trigger_event(event);
        }
        return this._queue = [];
    };

    return Channel;

})();
