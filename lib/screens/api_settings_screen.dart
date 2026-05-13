import 'package:flutter/material.dart';
import 'package:restaurant_flutter_app/util/api_config_service.dart';
import 'package:restaurant_flutter_app/util/styles.dart';
import 'package:restaurant_flutter_app/util/dimensions.dart';
import 'package:restaurant_flutter_app/common/widgets/custom_button_widget.dart';
import 'package:restaurant_flutter_app/common/widgets/custom_text_field_widget.dart';
import 'package:restaurant_flutter_app/common/widgets/snack_bar_widget.dart';

class ApiSettingsScreen extends StatefulWidget {
  const ApiSettingsScreen({super.key});

  @override
  State<ApiSettingsScreen> createState() => _ApiSettingsScreenState();
}

class _ApiSettingsScreenState extends State<ApiSettingsScreen> {
  late TextEditingController baseUrlController;
  late TextEditingController imageUrlController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    baseUrlController = TextEditingController();
    imageUrlController = TextEditingController();
    _loadCurrentUrls();
  }

  _loadCurrentUrls() async {
    final baseUrl = await ApiConfigService.getBaseUrl();
    final imageUrl = await ApiConfigService.getImageUrl();

    setState(() {
      baseUrlController.text = baseUrl;
      imageUrlController.text = imageUrl;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    baseUrlController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  _validateUrls() {
    final baseUrl = baseUrlController.text.trim();
    final imageUrl = imageUrlController.text.trim();

    if (baseUrl.isEmpty) {
      showCustomSnackBar(context, 'Base URL cannot be empty');
      return false;
    }

    if (imageUrl.isEmpty) {
      showCustomSnackBar(context, 'Image URL cannot be empty');
      return false;
    }

    // Basic URL validation
    try {
      Uri.parse(baseUrl);
      Uri.parse(imageUrl);
    } catch (e) {
      showCustomSnackBar(context, 'Invalid URL format');
      return false;
    }

    return true;
  }

  _saveSettings() async {
    if (!_validateUrls()) return;

    setState(() => isLoading = true);

    try {
      await ApiConfigService.setBaseUrl(baseUrlController.text.trim());
      await ApiConfigService.setImageUrl(imageUrlController.text.trim());

      if (mounted) {
        showCustomSnackBar(context, 'API settings saved successfully', isError: false);
        Navigator.pop(context, true); // Return true to indicate changes were made
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(context, 'Error saving settings');
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  _resetToDefaults() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset to Defaults?'),
          content: const Text('This will reset API URLs to default values. Continue?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await ApiConfigService.resetToDefaults();
                _loadCurrentUrls();
                if (mounted) {
                  showCustomSnackBar(context, 'Reset to default URLs', isError: false);
                }
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Settings'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configure API Endpoints',
                    style: robotoBold(context).copyWith(
                      fontSize: Dimensions.fontSizeLarge(context),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Text(
                    'Update the API base URL and image URL for your server',
                    style: robotoRegular(context).copyWith(
                      color: Colors.grey,
                      fontSize: Dimensions.fontSizeSmall(context),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                  Text(
                    'Base URL (API)',
                    style: robotoBold(context).copyWith(
                      fontSize: Dimensions.fontSizeDefault(context),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  CustomTextFieldWidget(
                    controller: baseUrlController,
                    labelText: 'Base URL',
                    hintText: 'http://192.168.92.174:8000/api',
                    inputType: TextInputType.url,
                    required: true,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                  Text(
                    'Image URL',
                    style: robotoBold(context).copyWith(
                      fontSize: Dimensions.fontSizeDefault(context),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  CustomTextFieldWidget(
                    controller: imageUrlController,
                    labelText: 'Image URL',
                    hintText: 'http://192.168.92.174:8000/',
                    inputType: TextInputType.url,
                    required: true,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          buttonText: 'Save',
                          onPressed: _saveSettings,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetToDefaults,
                          child: Text(
                            'Reset',
                            style: robotoBold(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                   const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                   Container(
                     padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                     decoration: BoxDecoration(
                       color: Colors.blue.withValues(alpha: 0.1),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           'ℹ️ Information',
                           style: robotoBold(context),
                         ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Text(
                          'Make sure the URLs are properly formatted and the server is accessible from your device.\n\nFor emulator testing with local server, use the host machine IP address instead of localhost/127.0.0.1.',
                          style: robotoRegular(context).copyWith(
                            fontSize: Dimensions.fontSizeSmall(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

