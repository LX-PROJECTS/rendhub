import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent_hub/core/theme/app_theme.dart';
import 'package:rent_hub/features/authentication/controller/image_picker_provider.dart';

class ProfileImageSelectorWidget extends ConsumerWidget {
  const ProfileImageSelectorWidget({
    super.key,
    required this.imageDbRef,
  });

  final String imageDbRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedImage = ref.watch(imagePickerProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(
        context.spaces.space_300 * 6,
      ),
      onTap: () {
        // pick image from gallery
        ref.read(imagePickerProvider.notifier).pickImage();
      },
      child: Stack(
        children: [
          CircleAvatar(
            radius: context.spaces.space_300 * 3.6,
            backgroundImage: pickedImage != null
                ? FileImage(File(pickedImage.path))
                : imageDbRef.isNotEmpty
                    ? NetworkImage(imageDbRef) as ImageProvider
                    : null,
            child: imageDbRef.isEmpty && pickedImage == null
                ? Icon(
                    Icons.person,
                    size: context.spaces.space_300 * 3.6,
                    color: context.colors.secondary,
                  )
                : null,
          ),
          Positioned(
            left: context.spaces.space_900 * 1.8,
            bottom: context.spaces.space_100 * 2,
            child: CircleAvatar(
              backgroundColor: context.colors.primary,
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
