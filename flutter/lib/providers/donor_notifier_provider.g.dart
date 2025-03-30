// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_notifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$donorHash() => r'686aa501be6ed11c1c024d17e1bdaedb4a5d017f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [donor].
@ProviderFor(donor)
const donorProvider = DonorFamily();

/// See also [donor].
class DonorFamily extends Family<AsyncValue<Donor?>> {
  /// See also [donor].
  const DonorFamily();

  /// See also [donor].
  DonorProvider call(
    String donorId,
  ) {
    return DonorProvider(
      donorId,
    );
  }

  @override
  DonorProvider getProviderOverride(
    covariant DonorProvider provider,
  ) {
    return call(
      provider.donorId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'donorProvider';
}

/// See also [donor].
class DonorProvider extends AutoDisposeFutureProvider<Donor?> {
  /// See also [donor].
  DonorProvider(
    String donorId,
  ) : this._internal(
          (ref) => donor(
            ref as DonorRef,
            donorId,
          ),
          from: donorProvider,
          name: r'donorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$donorHash,
          dependencies: DonorFamily._dependencies,
          allTransitiveDependencies: DonorFamily._allTransitiveDependencies,
          donorId: donorId,
        );

  DonorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.donorId,
  }) : super.internal();

  final String donorId;

  @override
  Override overrideWith(
    FutureOr<Donor?> Function(DonorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DonorProvider._internal(
        (ref) => create(ref as DonorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        donorId: donorId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Donor?> createElement() {
    return _DonorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DonorProvider && other.donorId == donorId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, donorId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DonorRef on AutoDisposeFutureProviderRef<Donor?> {
  /// The parameter `donorId` of this provider.
  String get donorId;
}

class _DonorProviderElement extends AutoDisposeFutureProviderElement<Donor?>
    with DonorRef {
  _DonorProviderElement(super.provider);

  @override
  String get donorId => (origin as DonorProvider).donorId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
