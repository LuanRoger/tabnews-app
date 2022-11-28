import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabnews/src/providers/favorites.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:tabnews/src/extensions/dark_mode.dart';
import 'package:tabnews/src/models/content.dart';
import 'package:tabnews/src/services/api.dart';
import 'package:tabnews/src/ui/widgets/markdown.dart';
import 'package:tabnews/src/ui/widgets/comments.dart';
import 'package:tabnews/src/ui/layouts/page.dart';
import 'package:tabnews/src/ui/widgets/progress_indicator.dart';

class ContentPage extends StatefulWidget {
  final String username;
  final String slug;

  const ContentPage({
    super.key,
    required this.username,
    required this.slug,
  });

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  Content content = Content.fromJson({});
  final api = Api();
  final ScrollController _controller = ScrollController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _getContent();
  }

  Future<void> _getContent() async {
    var contentResp = await api.fetchContent(
      '${widget.username}/${widget.slug}',
    );

    setState(() {
      content = contentResp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('pt-BR', timeago.PtBrMessages());

    return PageLayout(
      onRefresh: _getContent,
      actions: isLoading
          ? null
          : [
              Consumer<FavoritesProvider>(
                builder: (context, provider, _) => IconButton(
                  onPressed: () => provider.toggle(
                    content,
                  ),
                  icon: Icon(
                    provider.isFavorited(content.id!)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                ),
              ),
            ],
      body: isLoading
          ? const AppProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomScrollView(
                controller: _controller,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${content.ownerUsername} · ${timeago.format(DateTime.parse(content.publishedAt!), locale: "pt-BR")}',
                          style: const TextStyle().copyWith(
                            color: context.isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          content.parentId != null
                              ? 'Em resposta a...'
                              : '${content.title}',
                          style: const TextStyle().copyWith(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        MarkedownReader(
                          body: '${content.body}',
                          controller: _controller,
                        ),
                        const SizedBox(height: 30.0),
                        const Divider(),
                        const SizedBox(height: 30.0),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    child: CommentsRootWidget(
                      slug: '${widget.username}/${widget.slug}',
                      controller: _controller,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
