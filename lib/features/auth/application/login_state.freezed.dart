
part of 'login_state.dart';


T _$identity<T>(T value) => value;
mixin _$LoginState {

 bool get isSubmitting; FieldError? get usernameError; FieldError? get passwordError; LoginFailure? get failure; int get retryAfterSeconds; AuthUser? get user;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LoginState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.usernameError, _this.usernameError) || other.usernameError == _this.usernameError)&&(identical(other.passwordError, _this.passwordError) || other.passwordError == _this.passwordError)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.retryAfterSeconds, _this.retryAfterSeconds) || other.retryAfterSeconds == _this.retryAfterSeconds)&&(identical(other.user, _this.user) || other.user == _this.user));
}


@override
int get hashCode {
  final _this = this as LoginState;
  return Object.hash(runtimeType,_this.isSubmitting,_this.usernameError,_this.passwordError,_this.failure,_this.retryAfterSeconds,_this.user);
}

@override
String toString() {
  final _this = this as LoginState;
  return 'LoginState(isSubmitting: ${_this.isSubmitting}, usernameError: ${_this.usernameError}, passwordError: ${_this.passwordError}, failure: ${_this.failure}, retryAfterSeconds: ${_this.retryAfterSeconds}, user: ${_this.user})';
}


}

abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 bool isSubmitting, FieldError? usernameError, FieldError? passwordError, LoginFailure? failure, int retryAfterSeconds, AuthUser? user
});


$AuthUserCopyWith<$Res>? get user;

}
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? isSubmitting = null,Object? usernameError = freezed,Object? passwordError = freezed,Object? failure = freezed,Object? retryAfterSeconds = null,Object? user = freezed,}) {
  return _then(LoginState(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting
as bool,usernameError: freezed == usernameError ? _self.usernameError : usernameError
as FieldError?,passwordError: freezed == passwordError ? _self.passwordError : passwordError
as FieldError?,failure: freezed == failure ? _self.failure : failure
as LoginFailure?,retryAfterSeconds: null == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds
as int,user: freezed == user ? _self.user : user
as AuthUser?,
  ));
}
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $AuthUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


extension LoginStatePatterns on LoginState {

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that);case _:
  return null;

}
}

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSubmitting,  FieldError? usernameError,  FieldError? passwordError,  LoginFailure? failure,  int retryAfterSeconds,  AuthUser? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.isSubmitting,_that.usernameError,_that.passwordError,_that.failure,_that.retryAfterSeconds,_that.user);case _:
  return orElse();

}
}

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSubmitting,  FieldError? usernameError,  FieldError? passwordError,  LoginFailure? failure,  int retryAfterSeconds,  AuthUser? user)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.isSubmitting,_that.usernameError,_that.passwordError,_that.failure,_that.retryAfterSeconds,_that.user);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSubmitting,  FieldError? usernameError,  FieldError? passwordError,  LoginFailure? failure,  int retryAfterSeconds,  AuthUser? user)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.isSubmitting,_that.usernameError,_that.passwordError,_that.failure,_that.retryAfterSeconds,_that.user);case _:
  return null;

}
}

}



class _LoginState extends LoginState {
  const _LoginState({this.isSubmitting = false, this.usernameError, this.passwordError, this.failure, this.retryAfterSeconds = 0, this.user}): super._();
  

@override@JsonKey() final  bool isSubmitting;
@override final  FieldError? usernameError;
@override final  FieldError? passwordError;
@override final  LoginFailure? failure;
@override@JsonKey() final  int retryAfterSeconds;
@override final  AuthUser? user;

@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.usernameError, usernameError) || other.usernameError == usernameError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isSubmitting,usernameError,passwordError,failure,retryAfterSeconds,user);
}

@override
String toString() {
    return 'LoginState(isSubmitting: $isSubmitting, usernameError: $usernameError, passwordError: $passwordError, failure: $failure, retryAfterSeconds: $retryAfterSeconds, user: $user)';
}


}

abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSubmitting, FieldError? usernameError, FieldError? passwordError, LoginFailure? failure, int retryAfterSeconds, AuthUser? user
});


@override $AuthUserCopyWith<$Res>? get user;

}
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? isSubmitting = null,Object? usernameError = freezed,Object? passwordError = freezed,Object? failure = freezed,Object? retryAfterSeconds = null,Object? user = freezed,}) {
  return _then(_LoginState(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting
as bool,usernameError: freezed == usernameError ? _self.usernameError : usernameError
as FieldError?,passwordError: freezed == passwordError ? _self.passwordError : passwordError
as FieldError?,failure: freezed == failure ? _self.failure : failure
as LoginFailure?,retryAfterSeconds: null == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds
as int,user: freezed == user ? _self.user : user
as AuthUser?,
  ));
}

@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $AuthUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

