import 'package:flutter/material.dart';

import 'medha_ui.dart';
import 'profile.dart';
import 'services/api_service.dart';
import 'services/certificate_service.dart';
import 'services/user_service.dart';

class IqTestPage extends StatefulWidget {
  const IqTestPage({super.key});

  @override
  State<IqTestPage> createState() => _IqTestPageState();
}

class _IqTestPageState extends State<IqTestPage> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _authToken;
  List<_IqQuestion> _questions = const [];
  final Map<String, _IqOption> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final hasInternet = await ApiService.checkInternetConnection();
      if (!hasInternet) {
        setState(() {
          _errorMessage = 'No internet connection. Please check your network and try again.';
          _isLoading = false;
        });
        return;
      }

      await UserService.loadAuthToken();
      await UserService.loadUserFromStorage();
      _authToken = UserService.authToken;
      if (_authToken != null && _authToken!.isNotEmpty) {
        await UserService.fetchUserProfileFromAPI();
      }

      if (_authToken == null || _authToken!.isEmpty) {
        setState(() {
          _errorMessage = 'Please login first. MMCT requires your account token.';
          _isLoading = false;
        });
        return;
      }

      final user = UserService.currentUser;
      final hasSchool = user != null && user.schoolId != null && user.school.trim().isNotEmpty;

      if (!hasSchool) {
        setState(() {
          _errorMessage = 'Please complete your profile by selecting your school name before taking the MMCT.';
          _isLoading = false;
        });
        return;
      }

      final response = await ApiService.getIqQuestions(_authToken);
      final parsedQuestions = _parseQuestions(response.data);

      if (!mounted) return;

      setState(() {
        _questions = parsedQuestions;
        _errorMessage = response.success
            ? (parsedQuestions.isEmpty ? 'No MMCT questions were returned by the server.' : null)
            : (response.message.isNotEmpty ? response.message : 'Failed to load MMCT questions.');
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load MMCT questions: $e';
        _isLoading = false;
      });
    }
  }

  List<_IqQuestion> _parseQuestions(Map<String, dynamic>? payload) {
    if (payload == null) return const [];

    final candidates = [
      payload['data'],
      payload['questions'],
      payload['results'],
      payload['items'],
      payload,
    ];

    for (final candidate in candidates) {
      final list = _extractQuestionList(candidate);
      if (list.isNotEmpty) {
        return list;
      }
    }

    return const [];
  }

  List<_IqQuestion> _extractQuestionList(dynamic source) {
    if (source is List) {
      final questions = <_IqQuestion>[];
      for (var i = 0; i < source.length; i++) {
        final parsed = _IqQuestion.fromDynamic(source[i], i);
        if (parsed != null) {
          questions.add(parsed);
        }
      }
      return questions;
    }

    if (source is Map<String, dynamic>) {
      final nestedCandidates = [
        source['data'],
        source['questions'],
        source['results'],
        source['items'],
      ];

      for (final candidate in nestedCandidates) {
        final list = _extractQuestionList(candidate);
        if (list.isNotEmpty) {
          return list;
        }
      }
    }

    return const [];
  }

  Future<void> _submitTest() async {
    if (_isSubmitting || _questions.isEmpty) return;

    if (_selectedAnswers.length != _questions.length) {
      _showDialog(
        title: 'Incomplete Test',
        message: 'Please select one option for every question before submitting.',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final answers = _questions.map((question) {
      final selected = _selectedAnswers[question.id]!;
      return <String, dynamic>{
        'que': question.rawId,
        'given_answer': selected.rawId,
        'selected_answer': selected.value,
      };
    }).toList();

    final studentName = UserService.fullName.trim().isNotEmpty
        ? UserService.fullName.trim()
        : 'Student';
    final age = UserService.currentUser?.age ?? 0;

    final response = await ApiService.submitIqAnswers(
      _authToken,
      studentName,
      age,
      answers,
    );
    if (!mounted) return;

    setState(() => _isSubmitting = false);

    final iqScore = response.data?['your IQ'];
    final message = response.success
        ? 'Your MMCT has been submitted.'
        : (response.message.isNotEmpty
            ? response.message
            : 'Failed to submit MMCT.');

    if (response.success && iqScore != null) {
      await CertificateService.saveLatestIqCertificate(
        studentName: studentName,
        score: '$iqScore',
        completedAt: DateTime.now(),
      );
    }

    final shouldOpenCertificate = await _showDialog(
      title: response.success ? 'Submission Complete' : 'Submission Failed',
      message: message,
      iqScore: iqScore,
      showCertificateAction: response.success,
    );

    if (response.success && mounted) {
      if (shouldOpenCertificate) {
        Navigator.of(context).pushReplacementNamed('/certificate_download');
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  Future<bool> _showDialog({
    required String title,
    required String message,
    dynamic iqScore,
    bool showCertificateAction = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (iqScore != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: MedhaColors.hero,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: MedhaColors.primary, width: 1.2),
                ),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: MedhaColors.text,
                    ),
                    children: [
                      const TextSpan(
                        text: 'MMCI: ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: '$iqScore',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: MedhaColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (showCertificateAction) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: MedhaColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: MedhaColors.border),
                ),
                child: const Text(
                  'Your certificate is ready. Open the Certificates section to view and download it.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: MedhaColors.text,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (showCertificateAction)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Later',
                style: TextStyle(color: MedhaColors.primary),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(showCertificateAction),
            child: Text(
              showCertificateAction ? 'View Certificate' : 'OK',
              style: const TextStyle(color: MedhaColors.primary),
            ),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(
        title: 'MMCT',
        subtitle: 'Answer every question and submit your response',
      ),
      child: MedhaPageView(
        children: [
          MedhaHeroCard(
            title: 'Logical Intelligence Assessment',
            subtitle: _isLoading
                ? 'Loading your questions...'
                : _questions.isEmpty
                    ? 'We could not prepare the test right now.'
                    : 'Choose one option for each question and submit once you are done.',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.45),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '${_selectedAnswers.length}/${_questions.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: MedhaColors.text,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(color: MedhaColors.primary),
              ),
            )
          else if (_errorMessage != null)
            MedhaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Unable to load MMCT',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: MedhaColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: MedhaColors.muted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_errorMessage!.contains('school name')) ...[
                    MedhaPrimaryButton(
                      label: 'Complete Profile',
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditableProfilePage(startEditing: true),
                          ),
                        );
                        if (!mounted) return;
                        _loadQuestions();
                      },
                      icon: Icons.person_rounded,
                    ),
                  ] else
                    MedhaPrimaryButton(
                      label: 'Retry',
                      onPressed: _loadQuestions,
                      icon: Icons.refresh_rounded,
                    ),
                ],
              ),
            )
          else ...[
            ..._questions.asMap().entries.map((entry) {
              final questionNumber = entry.key + 1;
              final question = entry.value;
              final selectedValue = _selectedAnswers[question.id]?.id;

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: MedhaCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question $questionNumber',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: MedhaColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.text,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                          color: MedhaColors.text,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...question.options.map((option) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              setState(() {
                                _selectedAnswers[question.id] = option;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: selectedValue == option.id
                                    ? MedhaColors.hero
                                    : MedhaColors.surfaceAlt,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: selectedValue == option.id
                                      ? MedhaColors.primary
                                      : MedhaColors.border,
                                  width: selectedValue == option.id ? 1.6 : 1,
                                ),
                              ),
                              child: RadioListTile<String>(
                                value: option.id,
                                groupValue: selectedValue,
                                onChanged: (_) {
                                  setState(() {
                                    _selectedAnswers[question.id] = option;
                                  });
                                },
                                activeColor: MedhaColors.primary,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  option.value,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: MedhaColors.text,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 4),
            MedhaPrimaryButton(
              label: _isSubmitting ? 'Submitting...' : 'Submit Test',
              onPressed: _isSubmitting ? null : _submitTest,
              icon: Icons.send_rounded,
            ),
          ],
        ],
      ),
    );
  }
}

class _IqQuestion {
  final String id;
  final dynamic rawId;
  final String text;
  final List<_IqOption> options;

  const _IqQuestion({
    required this.id,
    required this.rawId,
    required this.text,
    required this.options,
  });

  static _IqQuestion? fromDynamic(dynamic source, int index) {
    if (source is! Map) return null;

    final map = Map<String, dynamic>.from(source as Map);
    final text = _readFirstString(map, [
      'que',
      'question',
      'question_text',
      'text',
      'title',
      'name',
    ]);

    if (text == null || text.isEmpty) return null;

    final rawId = map['id'] ?? map['question_id'] ?? map['pk'] ?? index + 1;
    final questionId = rawId.toString();
    final optionSource = map['options'] ?? map['choices'] ?? map['answers'] ?? map['response_options'];
    final options = _IqOption.listFromDynamic(optionSource);

    if (options.isEmpty) return null;

    return _IqQuestion(
      id: questionId,
      rawId: rawId,
      text: text,
      options: options,
    );
  }

  static String? _readFirstString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }
}

class _IqOption {
  final String id;
  final dynamic rawId;
  final String value;

  const _IqOption({
    required this.id,
    required this.rawId,
    required this.value,
  });

  static List<_IqOption> listFromDynamic(dynamic source) {
    if (source is! List) return const [];

    final options = <_IqOption>[];
    for (var i = 0; i < source.length; i++) {
      final option = source[i];
      if (option is Map) {
        final map = Map<String, dynamic>.from(option as Map);
        final rawId = map['id'] ?? map['option_id'] ?? map['pk'] ?? i + 1;
        final value = _readFirstString(map, [
          'options',
          'option',
          'text',
          'label',
          'title',
          'value',
          'answer',
        ]);

        if (value != null && value.isNotEmpty) {
          options.add(
            _IqOption(
              id: rawId.toString(),
              rawId: rawId,
              value: value,
            ),
          );
        }
        continue;
      }

      if (option is String && option.trim().isNotEmpty) {
        options.add(
          _IqOption(
            id: '${i + 1}',
            rawId: i + 1,
            value: option.trim(),
          ),
        );
      }
    }

    return options;
  }

  static String? _readFirstString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }
}
