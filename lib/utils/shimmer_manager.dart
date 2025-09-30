class ShimmerManager {
  static bool _hasShownShimmerGlobally = false;

  static bool get hasShownShimmer => _hasShownShimmerGlobally;

  static void markShimmerAsShown() {
    _hasShownShimmerGlobally = true;
  }

  static void resetShimmerState() {
    _hasShownShimmerGlobally = false;
  }
}
