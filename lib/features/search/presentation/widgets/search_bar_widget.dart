import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final List<String> suggestions;

  const SearchBarWidget({super.key, required this.controller, required this.onSearch, required this.suggestions});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _showSuggestions = false;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'app.search'.tr(),
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              widget.controller.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      widget.controller.clear();
                      setState(() {
                        _showSuggestions = false;
                      });
                    },
                  )
                  : null,
        ),
        onChanged: (value) {
          setState(() {
            _showSuggestions = value.isNotEmpty;
          });
        },
        onSubmitted: (value) {
          widget.onSearch(value);
          setState(() {
            _showSuggestions = false;
          });
        },
        onTap: () {
          if (widget.controller.text.isNotEmpty) {
            setState(() {
              _showSuggestions = true;
            });
          }
        },
      ),
      if (_showSuggestions && widget.controller.text.isNotEmpty)
        Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'search.suggestions'.tr(),
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                ),
              ),
              ...widget.suggestions
                  .where((suggestion) => suggestion.toLowerCase().contains(widget.controller.text.toLowerCase()))
                  .take(5)
                  .map(
                    (suggestion) => ListTile(
                      dense: true,
                      title: Text(suggestion, style: AppTextStyles.bodyMedium),
                      onTap: () {
                        widget.controller.text = suggestion;
                        widget.onSearch(suggestion);
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                    ),
                  ),
            ],
          ),
        ),
    ],
  );
}
