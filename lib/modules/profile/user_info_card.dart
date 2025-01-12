import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/models/user_model.dart';
import '../../shared/widgets/webview_page.dart';

class UserInfoCard extends StatelessWidget {
  final User user;

  const UserInfoCard({super.key, required this.user});

  void _openWebView(BuildContext context, String url, String title) async {
    if (kIsWeb) {
      print('Abrindo link: $url');
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir o link: $url')),
        );
      }
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WebViewPage(url: url, title: title),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _buildWebLayout(context) : _buildMobileLayout(context);
  }

  // Layout para web
  Widget _buildWebLayout(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 0,
      //margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl ?? 'https://example.com/default-avatar.png'),
                  radius: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? user.login,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '@${user.login}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            Text(
              user.bio ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            _buildIconWithText(context, 'assets/icons/Group.svg', '${user.followers} seguidores'),
            _buildIconWithText(context, 'assets/icons/Heart.svg', '${user.following} seguindo'),
            if (user.company != null && user.company!.isNotEmpty) _buildDetailRow(context, 'assets/icons/Office.svg', user.company)!,
            if (user.location != null && user.location!.isNotEmpty) _buildDetailRow(context, 'assets/icons/Pin.svg', user.location)!,
            if (user.email != null && user.email!.isNotEmpty) _buildDetailRow(context, 'assets/icons/Email.svg', user.email)!,
            if (user.blog != null && user.blog!.isNotEmpty) _buildLinkRow(context, 'assets/icons/Link.svg', user.blog!, 'Blog')!,
            if (user.twitterUsername != null && user.twitterUsername!.isNotEmpty)
              _buildLinkRow(
                context,
                'assets/icons/Twitter.svg',
                'https://twitter.com/${user.twitterUsername}', // URL correta
                '@${user.twitterUsername}', // Texto visível
              )!,
          ],
        ),
      ),
    );
  }

  // Layout para mobile
  Widget _buildMobileLayout(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl ?? 'https://example.com/default-avatar.png'),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? user.login,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '@${user.login}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              user.bio ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildIconWithText(context, 'assets/icons/Group.svg', '${user.followers} seguidores'),
                _buildIconWithText(context, 'assets/icons/Heart.svg', '${user.following} seguindo'),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                if (user.company != null && user.company!.isNotEmpty) _buildDetailRow(context, 'assets/icons/Office.svg', user.company)!,
                if (user.location != null && user.location!.isNotEmpty) _buildDetailRow(context, 'assets/icons/Pin.svg', user.location)!,
                if (user.email != null && user.email!.isNotEmpty) _buildDetailRow(context, 'assets/icons/Email.svg', user.email)!,
                if (user.blog != null && user.blog!.isNotEmpty) _buildLinkRow(context, 'assets/icons/Link.svg', user.blog, 'Blog')!,
                if (user.twitterUsername != null && user.twitterUsername!.isNotEmpty)
                  _buildLinkRow(
                    context,
                    'assets/icons/Twitter.svg',
                    'https://twitter.com/${user.twitterUsername}', // URL correta
                    '@${user.twitterUsername}', // Texto visível
                  )!,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWithText(BuildContext context, String iconPath, String text) {
    return Row(
      spacing: 4,
      children: [
        SvgPicture.asset(iconPath, height: 16),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget? _buildDetailRow(BuildContext context, String iconPath, String? text) {
    if (text == null || text.isEmpty) return null;

    return Row(
      spacing: 4,
      children: [
        SvgPicture.asset(iconPath, height: 22),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget? _buildLinkRow(BuildContext context, String iconPath, String? link, String title) {
    if (link == null || link.isEmpty) return null;
    return InkWell(
      onTap: () => _openWebView(context, link, title),
      child: _buildDetailRow(context, iconPath, link),
    );
  }
}
