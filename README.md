# DartSassPublishPlugin

This [Publish](https://github.com/JohnSundell/Publish) plugin compiles Sass files (.scss, .sass) into CSS files. It uses [Swift Sass](https://github.com/johnfairh/swift-sass) under the hood, which embeds the [Dart Sass](https://sass-lang.com/dart-sass/) compiler, the primary implementation of the Sass engine.

## Usage

The plugin compiles all the Sass files in a given directory:
```swift
try SomeSite().publish(using: [
    ...
    .installPlugin(.compileSass(from: "Sources/SomeSite/Theme/Stylesheets", to: "Resources/Stylesheets")),
    .copyResources(),
    ...
])
```

Then import the generated CSS files in your HTML code:
```swift
HTML(
    .head(
        .stylesheet("/Stylesheets/styles.css"),
    ),
    .body {
        ...
    }
)
```

## Contributing
If you find any issues or there is any missing feature you need, please feel free to create a Pull Request.