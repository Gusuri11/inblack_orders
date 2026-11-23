part of 'auth_models.dart';

T _$identity<T>(T value) => value;

mixin _$AuthUser {
  String get id;
  String get username;
  String get displayName;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<AuthUser> get copyWith =>
      _$AuthUserCopyWithImpl<AuthUser>(this as AuthUser, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as AuthUser;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthUser &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.username, _this.username) ||
                other.username == _this.username) &&
            (identical(other.displayName, _this.displayName) ||
                other.displayName == _this.displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as AuthUser;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.username,
      _this.displayName,
    );
  }

  @override
  String toString() {
    final _this = this as AuthUser;
    return 'AuthUser(id: ${_this.id}, username: ${_this.username}, displayName: ${_this.displayName})';
  }
}

abstract mixin class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) _then) =
      _$AuthUserCopyWithImpl;
  @useResult
  $Res call({String id, String username, String displayName});
}

class _$AuthUserCopyWithImpl<$Res> implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._self, this._then);

  final AuthUser _self;
  final $Res Function(AuthUser) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = null,
  }) {
    return _then(
      AuthUser(
        id: null == id ? _self.id : id as String,
        username: null == username ? _self.username : username as String,
        displayName: null == displayName
            ? _self.displayName
            : displayName as String,
      ),
    );
  }
}

extension AuthUserPatterns on AuthUser {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AuthUser value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AuthUser value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AuthUser value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String username, String displayName)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
        return $default(_that.id, _that.username, _that.displayName);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String username, String displayName) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser():
        return $default(_that.id, _that.username, _that.displayName);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String username, String displayName)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
        return $default(_that.id, _that.username, _that.displayName);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _AuthUser implements AuthUser {
  const _AuthUser({
    required this.id,
    required this.username,
    required this.displayName,
  });
  factory _AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String displayName;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthUserCopyWith<_AuthUser> get copyWith =>
      __$AuthUserCopyWithImpl<_AuthUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthUserToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthUser &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, id, username, displayName);
  }

  @override
  String toString() {
    return 'AuthUser(id: $id, username: $username, displayName: $displayName)';
  }
}

abstract mixin class _$AuthUserCopyWith<$Res>
    implements $AuthUserCopyWith<$Res> {
  factory _$AuthUserCopyWith(_AuthUser value, $Res Function(_AuthUser) _then) =
      __$AuthUserCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String username, String displayName});
}

class __$AuthUserCopyWithImpl<$Res> implements _$AuthUserCopyWith<$Res> {
  __$AuthUserCopyWithImpl(this._self, this._then);

  final _AuthUser _self;
  final $Res Function(_AuthUser) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = null,
  }) {
    return _then(
      _AuthUser(
        id: null == id ? _self.id : id as String,
        username: null == username ? _self.username : username as String,
        displayName: null == displayName
            ? _self.displayName
            : displayName as String,
      ),
    );
  }
}

mixin _$LoginResponse {
  String get accessToken;
  String get refreshToken;
  int get expiresIn;
  int get refreshExpiresIn;
  AuthUser get user;
  String get tokenType;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      _$LoginResponseCopyWithImpl<LoginResponse>(
        this as LoginResponse,
        _$identity,
      );

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as LoginResponse;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginResponse &&
            (identical(other.accessToken, _this.accessToken) ||
                other.accessToken == _this.accessToken) &&
            (identical(other.refreshToken, _this.refreshToken) ||
                other.refreshToken == _this.refreshToken) &&
            (identical(other.expiresIn, _this.expiresIn) ||
                other.expiresIn == _this.expiresIn) &&
            (identical(other.refreshExpiresIn, _this.refreshExpiresIn) ||
                other.refreshExpiresIn == _this.refreshExpiresIn) &&
            (identical(other.user, _this.user) || other.user == _this.user) &&
            (identical(other.tokenType, _this.tokenType) ||
                other.tokenType == _this.tokenType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as LoginResponse;
    return Object.hash(
      runtimeType,
      _this.accessToken,
      _this.refreshToken,
      _this.expiresIn,
      _this.refreshExpiresIn,
      _this.user,
      _this.tokenType,
    );
  }

  @override
  String toString() {
    final _this = this as LoginResponse;
    return 'LoginResponse(accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken}, expiresIn: ${_this.expiresIn}, refreshExpiresIn: ${_this.refreshExpiresIn}, user: ${_this.user}, tokenType: ${_this.tokenType})';
  }
}

abstract mixin class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
    LoginResponse value,
    $Res Function(LoginResponse) _then,
  ) = _$LoginResponseCopyWithImpl;
  @useResult
  $Res call({
    String accessToken,
    String refreshToken,
    int expiresIn,
    int refreshExpiresIn,
    AuthUser user,
    String tokenType,
  });

  $AuthUserCopyWith<$Res> get user;
}

class _$LoginResponseCopyWithImpl<$Res>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._self, this._then);

  final LoginResponse _self;
  final $Res Function(LoginResponse) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
    Object? refreshExpiresIn = null,
    Object? user = null,
    Object? tokenType = null,
  }) {
    return _then(
      LoginResponse(
        accessToken: null == accessToken
            ? _self.accessToken
            : accessToken as String,
        refreshToken: null == refreshToken
            ? _self.refreshToken
            : refreshToken as String,
        expiresIn: null == expiresIn ? _self.expiresIn : expiresIn as int,
        refreshExpiresIn: null == refreshExpiresIn
            ? _self.refreshExpiresIn
            : refreshExpiresIn as int,
        user: null == user ? _self.user : user as AuthUser,
        tokenType: null == tokenType ? _self.tokenType : tokenType as String,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<$Res> get user {
    return $AuthUserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

extension LoginResponsePatterns on LoginResponse {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LoginResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoginResponse() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LoginResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginResponse():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LoginResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginResponse() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String accessToken,
      String refreshToken,
      int expiresIn,
      int refreshExpiresIn,
      AuthUser user,
      String tokenType,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoginResponse() when $default != null:
        return $default(
          _that.accessToken,
          _that.refreshToken,
          _that.expiresIn,
          _that.refreshExpiresIn,
          _that.user,
          _that.tokenType,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String accessToken,
      String refreshToken,
      int expiresIn,
      int refreshExpiresIn,
      AuthUser user,
      String tokenType,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginResponse():
        return $default(
          _that.accessToken,
          _that.refreshToken,
          _that.expiresIn,
          _that.refreshExpiresIn,
          _that.user,
          _that.tokenType,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String accessToken,
      String refreshToken,
      int expiresIn,
      int refreshExpiresIn,
      AuthUser user,
      String tokenType,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginResponse() when $default != null:
        return $default(
          _that.accessToken,
          _that.refreshToken,
          _that.expiresIn,
          _that.refreshExpiresIn,
          _that.user,
          _that.tokenType,
        );
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _LoginResponse implements LoginResponse {
  const _LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.refreshExpiresIn,
    required this.user,
    this.tokenType = 'Bearer',
  });
  factory _LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final int expiresIn;
  @override
  final int refreshExpiresIn;
  @override
  final AuthUser user;
  @override
  @JsonKey()
  final String tokenType;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoginResponseCopyWith<_LoginResponse> get copyWith =>
      __$LoginResponseCopyWithImpl<_LoginResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LoginResponseToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoginResponse &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.refreshExpiresIn, refreshExpiresIn) ||
                other.refreshExpiresIn == refreshExpiresIn) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      accessToken,
      refreshToken,
      expiresIn,
      refreshExpiresIn,
      user,
      tokenType,
    );
  }

  @override
  String toString() {
    return 'LoginResponse(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, refreshExpiresIn: $refreshExpiresIn, user: $user, tokenType: $tokenType)';
  }
}

abstract mixin class _$LoginResponseCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$LoginResponseCopyWith(
    _LoginResponse value,
    $Res Function(_LoginResponse) _then,
  ) = __$LoginResponseCopyWithImpl;
  @override
  @useResult
  $Res call({
    String accessToken,
    String refreshToken,
    int expiresIn,
    int refreshExpiresIn,
    AuthUser user,
    String tokenType,
  });

  @override
  $AuthUserCopyWith<$Res> get user;
}

class __$LoginResponseCopyWithImpl<$Res>
    implements _$LoginResponseCopyWith<$Res> {
  __$LoginResponseCopyWithImpl(this._self, this._then);

  final _LoginResponse _self;
  final $Res Function(_LoginResponse) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
    Object? refreshExpiresIn = null,
    Object? user = null,
    Object? tokenType = null,
  }) {
    return _then(
      _LoginResponse(
        accessToken: null == accessToken
            ? _self.accessToken
            : accessToken as String,
        refreshToken: null == refreshToken
            ? _self.refreshToken
            : refreshToken as String,
        expiresIn: null == expiresIn ? _self.expiresIn : expiresIn as int,
        refreshExpiresIn: null == refreshExpiresIn
            ? _self.refreshExpiresIn
            : refreshExpiresIn as int,
        user: null == user ? _self.user : user as AuthUser,
        tokenType: null == tokenType ? _self.tokenType : tokenType as String,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<$Res> get user {
    return $AuthUserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

mixin _$RefreshResponse {
  String get accessToken;
  String get refreshToken;
  int get expiresIn;
  int get refreshExpiresIn;
  String get tokenType;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RefreshResponseCopyWith<RefreshResponse> get copyWith =>
      _$RefreshResponseCopyWithImpl<RefreshResponse>(
        this as RefreshResponse,
        _$identity,
      );

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as RefreshResponse;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RefreshResponse &&
            (identical(other.accessToken, _this.accessToken) ||
                other.accessToken == _this.accessToken) &&
            (identical(other.refreshToken, _this.refreshToken) ||
                other.refreshToken == _this.refreshToken) &&
            (identical(other.expiresIn, _this.expiresIn) ||
                other.expiresIn == _this.expiresIn) &&
            (identical(other.refreshExpiresIn, _this.refreshExpiresIn) ||
                other.refreshExpiresIn == _this.refreshExpiresIn) &&
            (identical(other.tokenType, _this.tokenType) ||
                other.tokenType == _this.tokenType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as RefreshResponse;
    return Object.hash(
      runtimeType,
      _this.accessToken,
      _this.refreshToken,
      _this.expiresIn,
      _this.refreshExpiresIn,
      _this.tokenType,
    );
  }

  @override
  String toString() {
    final _this = this as RefreshResponse;
    return 'RefreshResponse(accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken}, expiresIn: ${_this.expiresIn}, refreshExpiresIn: ${_this.refreshExpiresIn}, tokenType: ${_this.tokenType})';
  }
}

abstract mixin class $RefreshResponseCopyWith<$Res> {
  factory $RefreshResponseCopyWith(
    RefreshResponse value,
    $Res Function(RefreshResponse) _then,
  ) = _$RefreshResponseCopyWithImpl;
  @useResult
  $Res call({
    String accessToken,
    String refreshToken,
    int expiresIn,
    int refreshExpiresIn,
    String tokenType,
  });
}

class _$RefreshResponseCopyWithImpl<$Res>
    implements $RefreshResponseCopyWith<$Res> {
  _$RefreshResponseCopyWithImpl(this._self, this._then);

  final RefreshResponse _self;
  final $Res Function(RefreshResponse) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
    Object? refreshExpiresIn = null,
    Object? tokenType = null,
  }) {
    return _then(
      RefreshResponse(
        accessToken: null == accessToken
            ? _self.accessToken
            : accessToken as String,
        refreshToken: null == refreshToken
            ? _self.refreshToken
            : refreshToken as String,
        expiresIn: null == expiresIn ? _self.expiresIn : expiresIn as int,
        refreshExpiresIn: null == refreshExpiresIn
            ? _self.refreshExpiresIn
            : refreshExpiresIn as int,
        tokenType: null == tokenType ? _self.tokenType : tokenType as String,
      ),
    );
  }
}

extension RefreshResponsePatterns on RefreshResponse {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RefreshResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RefreshResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RefreshResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String accessToken,
      String refreshToken,
      int expiresIn,
      int refreshExpiresIn,
      String tokenType,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse() when $default != null:
        return $default(
          _that.accessToken,
          _that.refreshToken,
          _that.expiresIn,
          _that.refreshExpiresIn,
          _that.tokenType,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String accessToken,
      String refreshToken,
      int expiresIn,
      int refreshExpiresIn,
      String tokenType,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse():
        return $default(
          _that.accessToken,
          _that.refreshToken,
          _that.expiresIn,
          _that.refreshExpiresIn,
          _that.tokenType,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String accessToken,
      String refreshToken,
      int expiresIn,
      int refreshExpiresIn,
      String tokenType,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RefreshResponse() when $default != null:
        return $default(
          _that.accessToken,
          _that.refreshToken,
          _that.expiresIn,
          _that.refreshExpiresIn,
          _that.tokenType,
        );
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _RefreshResponse implements RefreshResponse {
  const _RefreshResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.refreshExpiresIn,
    this.tokenType = 'Bearer',
  });
  factory _RefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final int expiresIn;
  @override
  final int refreshExpiresIn;
  @override
  @JsonKey()
  final String tokenType;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RefreshResponseCopyWith<_RefreshResponse> get copyWith =>
      __$RefreshResponseCopyWithImpl<_RefreshResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RefreshResponseToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RefreshResponse &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.refreshExpiresIn, refreshExpiresIn) ||
                other.refreshExpiresIn == refreshExpiresIn) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      accessToken,
      refreshToken,
      expiresIn,
      refreshExpiresIn,
      tokenType,
    );
  }

  @override
  String toString() {
    return 'RefreshResponse(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, refreshExpiresIn: $refreshExpiresIn, tokenType: $tokenType)';
  }
}

abstract mixin class _$RefreshResponseCopyWith<$Res>
    implements $RefreshResponseCopyWith<$Res> {
  factory _$RefreshResponseCopyWith(
    _RefreshResponse value,
    $Res Function(_RefreshResponse) _then,
  ) = __$RefreshResponseCopyWithImpl;
  @override
  @useResult
  $Res call({
    String accessToken,
    String refreshToken,
    int expiresIn,
    int refreshExpiresIn,
    String tokenType,
  });
}

class __$RefreshResponseCopyWithImpl<$Res>
    implements _$RefreshResponseCopyWith<$Res> {
  __$RefreshResponseCopyWithImpl(this._self, this._then);

  final _RefreshResponse _self;
  final $Res Function(_RefreshResponse) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
    Object? refreshExpiresIn = null,
    Object? tokenType = null,
  }) {
    return _then(
      _RefreshResponse(
        accessToken: null == accessToken
            ? _self.accessToken
            : accessToken as String,
        refreshToken: null == refreshToken
            ? _self.refreshToken
            : refreshToken as String,
        expiresIn: null == expiresIn ? _self.expiresIn : expiresIn as int,
        refreshExpiresIn: null == refreshExpiresIn
            ? _self.refreshExpiresIn
            : refreshExpiresIn as int,
        tokenType: null == tokenType ? _self.tokenType : tokenType as String,
      ),
    );
  }
}
