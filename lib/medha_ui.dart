import 'package:flutter/material.dart';

class MedhaColors {
  static const Color page = Color(0xFFF4FBFA);
  static const Color hero = Color(0xFFBDF3EE);
  static const Color heroStrong = Color(0xFF96EFE6);
  static const Color primary = Color(0xFF0C7C72);
  static const Color primaryDark = Color(0xFF075C55);
  static const Color surface = Colors.white;
  static const Color surfaceAlt = Color(0xFFF3FAF9);
  static const Color border = Color(0xFFD8E7E4);
  static const Color text = Color(0xFF12222B);
  static const Color muted = Color(0xFF5F7179);
  static const Color danger = Color(0xFFC83E3E);
}

class MedhaScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final bool safeArea;

  const MedhaScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.safeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      children: [
        const Positioned(
          top: -90,
          left: -80,
          child: _Bubble(size: 250, color: Color(0xFFDDF3EF)),
        ),
        const Positioned(
          top: 120,
          right: -120,
          child: _Bubble(size: 240, color: Color(0xFFE9F6F3)),
        ),
        const Positioned(
          bottom: -120,
          left: -100,
          child: _Bubble(size: 260, color: Color(0xFFE3F2EF)),
        ),
        const Positioned(
          bottom: 50,
          right: -110,
          child: _Bubble(size: 220, color: Color(0xFFEDF8F6)),
        ),
        if (safeArea)
          SafeArea(child: child)
        else
          child,
      ],
    );

    return Scaffold(
      backgroundColor: MedhaColors.page,
      appBar: appBar,
      drawer: drawer,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class MedhaPageView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const MedhaPageView({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 24),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth > 600 ? 560.0 : double.infinity;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }
}

class MedhaTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool centerTitle;

  const MedhaTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 72 : 88);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: MedhaColors.text, size: 30),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: MedhaColors.text,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: const TextStyle(
                color: MedhaColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      actions: actions,
    );
  }
}

class MedhaHeroCard extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const MedhaHeroCard({
    super.key,
    this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [MedhaColors.heroStrong, MedhaColors.hero],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: MedhaColors.primary.withOpacity(0.10),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.35,
                    color: MedhaColors.text,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class MedhaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const MedhaCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MedhaColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: MedhaColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class MedhaIconTile extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const MedhaIconTile({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFE6F7F3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(icon, color: iconColor ?? MedhaColors.primary, size: size * 0.50),
    );
  }
}

class MedhaPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const MedhaPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: MedhaColors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}

class MedhaOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const MedhaOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: MedhaColors.primary,
          side: const BorderSide(color: MedhaColors.primary, width: 1.5),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}

class MedhaSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const MedhaSectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: MedhaColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: MedhaColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class MedhaMenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? iconBackground;
  final Color? textColor;
  final Widget? trailing;

  const MedhaMenuRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.iconBackground,
    this.textColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            MedhaIconTile(
              icon: icon,
              size: 52,
              backgroundColor: iconBackground ?? const Color(0xFFEAF6F4),
              iconColor: iconColor ?? MedhaColors.primary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: textColor ?? MedhaColors.text,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: MedhaColors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right_rounded, color: MedhaColors.muted, size: 28),
          ],
        ),
      ),
    );
  }
}

class MedhaTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;

  const MedhaTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: MedhaColors.text,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            keyboardType: keyboardType,
            onTap: onTap,
            readOnly: readOnly,
            style: const TextStyle(fontSize: 17, color: MedhaColors.text),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(prefixIcon, color: MedhaColors.muted),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: MedhaColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: MedhaColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: MedhaColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: MedhaColors.primary, width: 1.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MedhaBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MedhaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            active: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            active: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            active: currentIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE3F8F4) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? MedhaColors.primary : MedhaColors.text),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? MedhaColors.primary : MedhaColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final double size;
  final Color color;

  const _Bubble({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 2.3),
      ),
    );
  }
}
