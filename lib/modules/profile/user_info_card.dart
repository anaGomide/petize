import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../shared/models/user_model.dart';
import '../../shared/widgets/webview_page.dart';

class UserInfoCard extends StatelessWidget {
  final User user;

  const UserInfoCard({super.key, required this.user});

  void _openWebView(BuildContext context, String url, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Elevação suave para dar destaque

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome e login do usuário
            Row(
              spacing: 16,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                  radius: 30, // Tamanho do avatar
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome
                    Text(
                      user.name ?? user.login,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    // Login
                    Text(
                      '@${user.login}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),

            // Seguidores e seguindo
            Row(
              spacing: 16,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/Group.svg', height: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${user.followers} seguidores',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/Heart.svg', height: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${user.following} seguindo',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),

            // Bio do usuário
            if (user.bio != null && user.bio!.isNotEmpty)
              Text(
                user.bio!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

            // Empresa, localização e email
            Wrap(
              spacing: 8,
              children: [
                if (user.company != null && user.company!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/icons/Office.svg', height: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          user.company!,
                          style: Theme.of(context).textTheme.bodySmall,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                if (user.location != null && user.location!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/icons/Pin.svg', height: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          user.location!,
                          style: Theme.of(context).textTheme.bodySmall,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                if (user.email != null && user.email!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/icons/Email.svg', height: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          user.email!,
                          style: Theme.of(context).textTheme.bodySmall,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            // Link e Twitter
            Wrap(
              children: [
                if (user.blog != null && user.blog!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/icons/Link.svg', height: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        child: InkWell(
                          onTap: () => _openWebView(context, user.blog!, 'Blog'),
                          child: Text(
                            user.blog!,
                            style: Theme.of(context).textTheme.bodySmall,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (user.twitterUsername != null && user.twitterUsername!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/icons/Twitter.svg', height: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        child: InkWell(
                          onTap: () => _openWebView(
                            context,
                            'https://twitter.com/${user.twitterUsername}',
                            'Twitter',
                          ),
                          child: Text(
                            '@${user.twitterUsername}',
                            style: Theme.of(context).textTheme.bodySmall,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
