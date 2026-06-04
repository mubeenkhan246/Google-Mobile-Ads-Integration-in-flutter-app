enum AdLoadStatus { idle, loading, loaded, failed }

class AdLoadState {
  const AdLoadState({this.status = AdLoadStatus.idle, this.message});

  final AdLoadStatus status;
  final String? message;

  bool get isLoading => status == AdLoadStatus.loading;
  bool get isLoaded => status == AdLoadStatus.loaded;

  AdLoadState copyWith({AdLoadStatus? status, String? message}) {
    return AdLoadState(status: status ?? this.status, message: message);
  }
}
