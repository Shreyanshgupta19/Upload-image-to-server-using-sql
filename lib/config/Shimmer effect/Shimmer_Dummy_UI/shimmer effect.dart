import 'package:flutter/material.dart';
import 'package:upload_image_to_server_using_sql/config/Shimmer%20effect/Shimmer_Group_Widget/shimmer_group_widget.dart';
import 'package:upload_image_to_server_using_sql/config/Shimmer%20effect/Shimmer_Widget/shimmer_container.dart';

class ShimmerFormLoading extends StatelessWidget {
  const ShimmerFormLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // for Profile
            ShimmerGroup(
              rowMainAxisAlignment: MainAxisAlignment.end,
              rowCrossAxisAlignment: CrossAxisAlignment.center,
              columnMainAxisAlignment: MainAxisAlignment.center,
              columnCrossAxisAlignment: CrossAxisAlignment.end,
              insideChildren: [
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

            // Name field shimmer
            buildShimmerLabel(),
            const SizedBox(height: 8),
            buildShimmerField(height: 48),
            const SizedBox(height: 24),

            // Email field shimmer
            buildShimmerLabel(),
            const SizedBox(height: 8),
            buildShimmerField(height: 48),
            const SizedBox(height: 24),

            // Message field shimmer
            buildShimmerLabel(),
            const SizedBox(height: 8),
            buildShimmerField(height: 48),
            const SizedBox(height: 24),
            buildShimmerLabel(),
            const SizedBox(height: 8),
            buildShimmerField(height: 80, width: 80),
            const SizedBox(height: 24),
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
    );
  }

}




