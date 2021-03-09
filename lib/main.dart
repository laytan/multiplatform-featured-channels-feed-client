import 'package:flutter/material.dart';
import 'package:multiplatform/featured_channels_state.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => FeaturedChannelsState(
          'https://featured-channels-crawler-icwo3623mq-ez.a.run.app/'),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Featured Channels Feed',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Featured Channels Feed'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _channelInputController = TextEditingController();

  @override
  void dispose() {
    _channelInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              constraints: BoxConstraints(maxWidth: 1300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Featured Channels Feed',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 32,
                      )),
                  Wrap(
                    children: <Widget>[
                      Text('All Featured Channels in ',
                          style: TextStyle(
                            fontSize: 24,
                          )),
                      Text('one place.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          )),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _channelInputController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a channel name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffix: Consumer<FeaturedChannelsState>(
                              builder: (context, state, child) => SizedBox(
                                width: 140,
                                child: ElevatedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Get video\'s'),
                                        Icon(Icons.arrow_right),
                                      ],
                                    ),
                                  ),
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            state.fetchForChannel(
                                                _channelInputController.text);
                                          }
                                        },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Consumer<FeaturedChannelsState>(
                          builder: (context, state, child) {
                            if (state.isLoading) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Loading ',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(width: 8),
                                    SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator()),
                                  ],
                                ),
                              );
                            }

                            if (state.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Text(state.error,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 24)),
                                ),
                              );
                            }

                            if (state.hasChannels) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: ResponsiveGridRow(children: <
                                    ResponsiveGridCol>[
                                  for (var video in state.videos)
                                    ResponsiveGridCol(
                                      md: 6,
                                      xl: 3,
                                      child: Card(
                                        margin: EdgeInsets.all(8),
                                        child: Tooltip(
                                          message: video.fullURL,
                                          child: InkWell(
                                            onTap: () async {
                                              if (await canLaunch(
                                                  video.fullURL)) {
                                                await launch(video.fullURL);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Could not open link: ' +
                                                          video.url),
                                                ));
                                              }
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.network(
                                                    video.thumbnailURL,
                                                    alignment:
                                                        Alignment.topCenter,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(video.title,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16)),
                                                      Text(video.channelTitle +
                                                          ' - ' +
                                                          video.publishedAt +
                                                          ' - ' +
                                                          video.views),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ]),
                              );
                            }

                            return Container();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
