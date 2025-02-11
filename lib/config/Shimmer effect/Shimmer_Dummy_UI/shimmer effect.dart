import 'package:flutter/material.dart';
import 'package:upload_image_to_server_using_sql/config/Shimmer%20effect/Shimmer_Group_Widget/shimmer_group_widget.dart';
import 'package:upload_image_to_server_using_sql/config/Shimmer%20effect/Shimmer_Widget/shimmer_container.dart';

class ShimmerFormLoading extends StatelessWidget {
  const ShimmerFormLoading({super.key});

  @override
  Widget build(BuildContext context) {
      return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // for Profile
                ShimmerGroup(
                  rowMainAxisAlignment: MainAxisAlignment.end,
                  rowCrossAxisAlignment: CrossAxisAlignment.center,
                  columnMainAxisAlignment: MainAxisAlignment.center,
                  columnCrossAxisAlignment: CrossAxisAlignment.end,
                  insideChildren: [
                    const SizedBox(height: 24),
                    buildShimmerField(height: 48, width: 48, radius: 100),
                    const SizedBox(height: 8),
                    buildShimmerLabel(),
                    const SizedBox(height: 8),
                    buildShimmerField(height: 18, width: 100),
                    const SizedBox(height: 8),
                    buildShimmerField(height: 18, width: 150),
                    const SizedBox(height: 24),
                  ],
                ),

                // Form field shimmer
                buildShimmerLabel(),
                const SizedBox(height: 8),
                buildShimmerField(height: 48),
                const SizedBox(height: 24),
                buildShimmerLabel(),
                const SizedBox(height: 8),
                buildShimmerField(height: 48),
                const SizedBox(height: 24),
                buildShimmerLabel(),
                const SizedBox(height: 8),
                buildShimmerField(height: 48),
                const SizedBox(height: 24),

                // Camera field shimmer
                buildShimmerLabel(),
                const SizedBox(height: 8),
                buildShimmerField(height: 80, width: 80),
                const SizedBox(height: 24),

                // Form field shimmer
                buildShimmerLabel(),
                const SizedBox(height: 8),
                buildShimmerField(height: 48),
                const SizedBox(height: 24),


                // Button shimmer
                Center(
                  child: buildShimmerField(height: 48, width: 200),
                ),
                const SizedBox(height: 24),

              ],
            ),
          ),
        ),
      ),
    );
  }

}

