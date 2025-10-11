import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:norkacare_app/utils/constants.dart';

class ShimmerWidgets {
  static Widget buildShimmerWelcomeSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Logo shimmer
              Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.8),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    // Title shimmer
                    Shimmer.fromColors(
                      baseColor: Colors.white.withOpacity(0.2),
                      highlightColor: Colors.white.withOpacity(0.8),
                      child: Container(
                        height: 20,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Norka ID shimmer
                    Shimmer.fromColors(
                      baseColor: Colors.white.withOpacity(0.2),
                      highlightColor: Colors.white.withOpacity(0.8),
                      child: Container(
                        height: 16,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Coverage card shimmer
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 12,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 20,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 12,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildShimmerQuickOverview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.grey.withOpacity(0.8),
            child: Container(
              height: 20,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // First row of cards
          Row(
            children: [
              Expanded(child: _buildShimmerStatCard()),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerStatCard()),
            ],
          ),
          const SizedBox(height: 12),
          // Second row of cards
          Row(
            children: [
              Expanded(child: _buildShimmerStatCard()),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerStatCard()),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildShimmerStatCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.withOpacity(0.5),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 18,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 12,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildShimmerDocumentsSection({bool isDarkMode = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer
          Shimmer.fromColors(
            baseColor: isDarkMode
                ? Colors.grey.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            highlightColor: isDarkMode
                ? Colors.grey.withOpacity(0.6)
                : Colors.grey.withOpacity(0.8),
            child: Container(
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                color: isDarkMode ? AppConstants.boxBlackColor : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Document cards shimmer
          _buildShimmerDocumentCard(isDarkMode: isDarkMode),
          const SizedBox(height: 12),
          _buildShimmerDocumentCard(isDarkMode: isDarkMode),
        ],
      ),
    );
  }

  static Widget _buildShimmerDocumentCard({bool isDarkMode = false}) {
    return Shimmer.fromColors(
      baseColor: isDarkMode
          ? Colors.grey.withOpacity(0.4)
          : Colors.grey.withOpacity(0.3),
      highlightColor: isDarkMode
          ? Colors.grey.withOpacity(0.7)
          : Colors.grey.withOpacity(0.5),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppConstants.boxBlackColor : Colors.grey,
          borderRadius: BorderRadius.circular(12),
          border: isDarkMode
              ? Border.all(color: Colors.white.withOpacity(0.1), width: 1)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.withOpacity(0.3) : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 80,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 12,
                    width: 60,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.withOpacity(0.3) : Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildShimmerQuickActionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.grey.withOpacity(0.8),
            child: Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildShimmerActionCard()),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerActionCard()),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildShimmerActionCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.withOpacity(0.5),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 12,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildShimmerPolicyCard({bool isDarkMode = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: isDarkMode
            ? Colors.grey.withOpacity(0.4)
            : Colors.grey.withOpacity(0.3),
        highlightColor: isDarkMode
            ? Colors.grey.withOpacity(0.7)
            : Colors.grey.withOpacity(0.5),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? AppConstants.boxBlackColor : Colors.grey,
            borderRadius: BorderRadius.circular(12),
            border: isDarkMode
                ? Border.all(color: Colors.white.withOpacity(0.1), width: 1)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title shimmer
              Container(
                height: 20,
                width: 120,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey.withOpacity(0.3)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),

              // Policy details grid shimmer
              _buildShimmerPolicyDetailsGrid(isDarkMode: isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildShimmerPolicyDetailsGrid({bool isDarkMode = false}) {
    return Column(
      children: [
        // First Row
        Row(
          children: [
            Expanded(
              child: _buildShimmerPolicyDetailItem(isDarkMode: isDarkMode),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildShimmerPolicyDetailItem(isDarkMode: isDarkMode),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Second Row
        Row(
          children: [
            Expanded(
              child: _buildShimmerPolicyDetailItem(isDarkMode: isDarkMode),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildShimmerPolicyDetailItem(isDarkMode: isDarkMode),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Third Row
        Row(
          children: [
            Expanded(
              child: _buildShimmerPolicyDetailItem(isDarkMode: isDarkMode),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildShimmerPolicyDetailItem(isDarkMode: isDarkMode),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Fourth Row
        Row(
          children: [
            Expanded(
              child: _buildShimmerPolicyDetailItem(isDarkMode: isDarkMode),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildShimmerPolicyDetailItem(isDarkMode: isDarkMode),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildShimmerPolicyDetailItem({bool isDarkMode = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 12,
          width: 80,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.withOpacity(0.3) : Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 14,
          width: 100,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.withOpacity(0.3) : Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  static Widget buildShimmerSearchAndFilterSection({bool isDarkMode = false}) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: isDarkMode
            ? Colors.grey.withOpacity(0.4)
            : Colors.grey.withOpacity(0.3),
        highlightColor: isDarkMode
            ? Colors.grey.withOpacity(0.7)
            : Colors.grey.withOpacity(0.5),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? AppConstants.boxBlackColor : Colors.grey,
            borderRadius: BorderRadius.circular(12),
            border: isDarkMode
                ? Border.all(color: Colors.white.withOpacity(0.1), width: 1)
                : null,
          ),
          child: Container(
            height: 50,
            child: Row(
              children: [
                _buildShimmerFilterChip(isDarkMode: isDarkMode),
                const SizedBox(width: 12),
                _buildShimmerFilterChip(isDarkMode: isDarkMode),
                const SizedBox(width: 12),
                _buildShimmerFilterChip(isDarkMode: isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildShimmerFilterChip({bool isDarkMode = false}) {
    return Container(
      height: 40,
      width: 60,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.withOpacity(0.3) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  // Documents Page Shimmer Widgets
  static Widget buildShimmerDocumentsPage({bool isDarkMode = false}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildShimmerDocumentsPageCard(isDarkMode: isDarkMode),
          const SizedBox(height: 16),
          _buildShimmerDocumentsPageCard(isDarkMode: isDarkMode),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Claims Page Shimmer Widgets
  static Widget buildShimmerClaimsPage({bool isDarkMode = false}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search and filter section shimmer
          buildShimmerSearchAndFilterSection(isDarkMode: isDarkMode),
          const SizedBox(height: 20),
          // Claims count shimmer
          _buildShimmerClaimsCount(isDarkMode: isDarkMode),
          const SizedBox(height: 16),
          // Claims cards shimmer
          _buildShimmerClaimCard(isDarkMode: isDarkMode),
          const SizedBox(height: 16),
          _buildShimmerClaimCard(isDarkMode: isDarkMode),
          const SizedBox(height: 16),
          _buildShimmerClaimCard(isDarkMode: isDarkMode),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  static Widget _buildShimmerClaimsCount({bool isDarkMode = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Shimmer.fromColors(
        baseColor: isDarkMode
            ? Colors.grey.withOpacity(0.4)
            : Colors.grey.withOpacity(0.3),
        highlightColor: isDarkMode
            ? Colors.grey.withOpacity(0.7)
            : Colors.grey.withOpacity(0.5),
        child: Container(
          height: 20,
          width: 150,
          decoration: BoxDecoration(
            color: isDarkMode ? AppConstants.boxBlackColor : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  static Widget _buildShimmerClaimCard({bool isDarkMode = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Shimmer.fromColors(
        baseColor: isDarkMode
            ? Colors.grey.withOpacity(0.4)
            : Colors.grey.withOpacity(0.3),
        highlightColor: isDarkMode
            ? Colors.grey.withOpacity(0.7)
            : Colors.grey.withOpacity(0.5),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppConstants.boxBlackColor : Colors.grey,
            borderRadius: BorderRadius.circular(12),
            border: isDarkMode
                ? Border.all(color: Colors.white.withOpacity(0.1), width: 1)
                : null,
          ),
          child: Column(
            children: [
              // Header shimmer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 16,
                            width: 120,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 12,
                            width: 80,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 18,
                          width: 60,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey.withOpacity(0.3)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 12,
                          width: 40,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey.withOpacity(0.3)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Details shimmer
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildShimmerDetailRow(isDarkMode: isDarkMode),
                    const SizedBox(height: 6),
                    _buildShimmerDetailRow(isDarkMode: isDarkMode),
                    const SizedBox(height: 6),
                    _buildShimmerDetailRow(isDarkMode: isDarkMode),
                  ],
                ),
              ),
              // Action buttons shimmer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey.withOpacity(0.3)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey.withOpacity(0.3)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildShimmerDetailRow({bool isDarkMode = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 14,
          width: 80,
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.grey.withOpacity(0.3)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const Spacer(),
        Container(
          height: 14,
          width: 100,
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.grey.withOpacity(0.3)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  // Helper method to build shimmer document card for documents page
  static Widget _buildShimmerDocumentsPageCard({bool isDarkMode = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppConstants.boxBlackColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        border: isDarkMode
            ? Border.all(color: Colors.white.withOpacity(0.1), width: 1)
            : null,
      ),
      child: Column(
        children: [
          // Header shimmer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppConstants.darkBackgroundColor
                  : Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey.withOpacity(0.3)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey.withOpacity(0.3)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 13,
                        width: 80,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey.withOpacity(0.3)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 24,
                  width: 50,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey.withOpacity(0.3)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
          // Action button shimmer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppConstants.darkBackgroundColor
                  : Colors.grey[200],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey.withOpacity(0.3)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
