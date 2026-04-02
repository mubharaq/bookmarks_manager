import 'package:bookmarks_manager/domain/models/category/category.dart';
import 'package:bookmarks_manager/extensions/ref_extension.dart';
import 'package:bookmarks_manager/ui/core/helper.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_button.dart';
import 'package:bookmarks_manager/ui/core/widgets/form/app_text_field.dart';
import 'package:bookmarks_manager/ui/core/widgets/touchable_opacity.dart';
import 'package:bookmarks_manager/ui/features/collections/view_model/collections_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _presetColors = [
  '#2E4D44',
  '#5C6B80',
  '#008751',
  '#8B5E3C',
  '#7C3AED',
  '#B45309',
  '#0369A1',
  '#BE123C',
];

const _presetIcons = [
  '📚',
  '💻',
  '🎨',
  '🛠️',
  '🎵',
  '🎬',
  '✈️',
  '📊',
  '🔬',
  '🍳',
  '🏠',
  '💰',
  '📰',
  '🎮',
  '🏋️',
  '🌍',
];

class CollectionFormSheet extends ConsumerStatefulWidget {
  const CollectionFormSheet({this.category, super.key});

  final Category? category;

  static Future<void> show(BuildContext context, {Category? category}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CollectionFormSheet(category: category),
    );
  }

  @override
  ConsumerState<CollectionFormSheet> createState() =>
      _CollectionFormSheetState();
}

class _CollectionFormSheetState extends ConsumerState<CollectionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _isFormValid = ValueNotifier<bool>(false);
  late final _nameController = TextEditingController(
    text: widget.category?.name,
  );
  late String? _selectedColor = widget.category?.color;
  late String? _selectedIcon = widget.category?.icon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFormValid.value = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _isFormValid.dispose();
    super.dispose();
  }

  Future<void> addCollection() async {
    final isFormValid =
        (_formKey.currentState?.validate() ?? false) &&
        _selectedColor != null &&
        _selectedIcon != null;
    if (!isFormValid) return;
    await addCollectionMutation.run(ref, (
      tsx,
    ) {
      return tsx
          .get(
            collectionsViewModelProvider.notifier,
          )
          .addCollection(
            name: _nameController.text,
            color: _selectedColor!,
            icon: _selectedIcon!,
          );
    }).suppress();
    if (!mounted) return;
    if (!ref.read(addCollectionMutation).hasError) Navigator.pop(context);
  }

  Future<void> updateCollection() async {
    final isFormValid =
        (_formKey.currentState?.validate() ?? false) &&
        _selectedColor != null &&
        _selectedIcon != null &&
        widget.category != null;
    if (!isFormValid) return;
    await editCollectionMutation.run(ref, (
      tsx,
    ) async {
      return tsx
          .get(
            collectionsViewModelProvider.notifier,
          )
          .updateCollection(
            id: widget.category!.id,
            name: _nameController.text,
            color: _selectedColor!,
            icon: _selectedIcon!,
          );
    }).suppress();
    if (!mounted) return;
    if (!ref.read(editCollectionMutation).hasError) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = widget.category != null;
    final isLoading =
        ref.watch(addCollectionMutation).isPending ||
        ref.watch(editCollectionMutation).isPending;

    return PopScope(
      canPop: !isLoading,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0).copyWith(
          bottom: MediaQuery.viewInsetsOf(context).bottom + 32.h,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            onChanged: () =>
                _isFormValid.value = _formKey.currentState?.validate() ?? false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Collection' : 'New Collection',
                  style: AppTextStyles.text.xl.bold,
                ),
                20.verticalSpace,
                AppTextField(
                  hintText: 'Collection name',
                  controller: _nameController,
                  inputAction: TextInputAction.done,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Name is required' : null,
                ),
                20.verticalSpace,
                Text('Color', style: AppTextStyles.text.sm.semibold),
                10.verticalSpace,
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: _presetColors.map((hex) {
                    final isSelected = _selectedColor == hex;
                    return TouchableOpacity(
                      onTap: () => setState(() => _selectedColor = hex),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: hexToColor(hex),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.onSurface
                                : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: hexToColor(
                                      hex,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                size: 16.sp,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                20.verticalSpace,
                Text(
                  'Icon',
                  style: AppTextStyles.text.sm.semibold.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                10.verticalSpace,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _presetIcons.map((emoji) {
                    final isSelected = _selectedIcon == emoji;
                    final isColorSelected = _selectedColor != null;
                    return TouchableOpacity(
                      onTap: () => setState(() => _selectedIcon = emoji),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: (isSelected && isColorSelected)
                              ? hexToColor(
                                  _selectedColor!,
                                ).withValues(alpha: 0.15)
                              : colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: (isSelected && isColorSelected)
                                ? hexToColor(_selectedColor!)
                                : Colors.transparent,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                24.verticalSpace,
                ValueListenableBuilder(
                  valueListenable: _isFormValid,
                  builder: (context, isValid, _) {
                    final isFormValid =
                        isValid &&
                        _selectedColor != null &&
                        _selectedIcon != null;
                    return AppButton(
                      isLoading: isLoading,
                      label: isEditing
                          ? 'Update Collection'
                          : 'Create Collection',
                      isDisabled: !isFormValid,
                      onPressed: () async {
                        if (isEditing) {
                          await updateCollection();
                        } else {
                          await addCollection();
                        }
                      },
                    );
                  },
                ),

                12.verticalSpace,
                AppButton(
                  label: 'Cancel',
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  variant: ButtonVariant.neutral,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
