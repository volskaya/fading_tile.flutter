// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomePageState {
  List<ChatMessage> get paginated => throw _privateConstructorUsedError;
  List<ChatMessage> get subscribed => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomePageStateCopyWith<HomePageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePageStateCopyWith<$Res> {
  factory $HomePageStateCopyWith(
          HomePageState value, $Res Function(HomePageState) then) =
      _$HomePageStateCopyWithImpl<$Res, HomePageState>;
  @useResult
  $Res call({List<ChatMessage> paginated, List<ChatMessage> subscribed});
}

/// @nodoc
class _$HomePageStateCopyWithImpl<$Res, $Val extends HomePageState>
    implements $HomePageStateCopyWith<$Res> {
  _$HomePageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paginated = null,
    Object? subscribed = null,
  }) {
    return _then(_value.copyWith(
      paginated: null == paginated
          ? _value.paginated
          : paginated // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      subscribed: null == subscribed
          ? _value.subscribed
          : subscribed // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomePageStateImplCopyWith<$Res>
    implements $HomePageStateCopyWith<$Res> {
  factory _$$HomePageStateImplCopyWith(
          _$HomePageStateImpl value, $Res Function(_$HomePageStateImpl) then) =
      __$$HomePageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ChatMessage> paginated, List<ChatMessage> subscribed});
}

/// @nodoc
class __$$HomePageStateImplCopyWithImpl<$Res>
    extends _$HomePageStateCopyWithImpl<$Res, _$HomePageStateImpl>
    implements _$$HomePageStateImplCopyWith<$Res> {
  __$$HomePageStateImplCopyWithImpl(
      _$HomePageStateImpl _value, $Res Function(_$HomePageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paginated = null,
    Object? subscribed = null,
  }) {
    return _then(_$HomePageStateImpl(
      paginated: null == paginated
          ? _value._paginated
          : paginated // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      subscribed: null == subscribed
          ? _value._subscribed
          : subscribed // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
    ));
  }
}

/// @nodoc

class _$HomePageStateImpl extends _HomePageState {
  const _$HomePageStateImpl(
      {final List<ChatMessage> paginated = const [],
      final List<ChatMessage> subscribed = const []})
      : _paginated = paginated,
        _subscribed = subscribed,
        super._();

  final List<ChatMessage> _paginated;
  @override
  @JsonKey()
  List<ChatMessage> get paginated {
    if (_paginated is EqualUnmodifiableListView) return _paginated;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paginated);
  }

  final List<ChatMessage> _subscribed;
  @override
  @JsonKey()
  List<ChatMessage> get subscribed {
    if (_subscribed is EqualUnmodifiableListView) return _subscribed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subscribed);
  }

  @override
  String toString() {
    return 'HomePageState(paginated: $paginated, subscribed: $subscribed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomePageStateImpl &&
            const DeepCollectionEquality()
                .equals(other._paginated, _paginated) &&
            const DeepCollectionEquality()
                .equals(other._subscribed, _subscribed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_paginated),
      const DeepCollectionEquality().hash(_subscribed));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomePageStateImplCopyWith<_$HomePageStateImpl> get copyWith =>
      __$$HomePageStateImplCopyWithImpl<_$HomePageStateImpl>(this, _$identity);
}

abstract class _HomePageState extends HomePageState {
  const factory _HomePageState(
      {final List<ChatMessage> paginated,
      final List<ChatMessage> subscribed}) = _$HomePageStateImpl;
  const _HomePageState._() : super._();

  @override
  List<ChatMessage> get paginated;
  @override
  List<ChatMessage> get subscribed;
  @override
  @JsonKey(ignore: true)
  _$$HomePageStateImplCopyWith<_$HomePageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
