//
//  ContentView.swift
//  Recoreon
//
//  Created by Kaito Udagawa on 2023/11/01.
//

import SwiftUI

struct RecordedVideoEntry: Identifiable {
  let url: URL
  let uiImage: UIImage

  var id: URL { url }
}

struct ContentView: View {
  @State var entries: [RecordedVideoEntry]

  @State var encodingScreenIsPresented: Bool = false

  @State private var encodingEntry: RecordedVideoEntry = RecordedVideoEntry(url: URL(fileURLWithPath: ""), uiImage: UIImage(named: "AppIcon")!)

  @State private var encodingProgress: Double = 0.0

  let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

  var body: some View {
    VStack {
      List {
        LazyVGrid(columns: columns) {
          ForEach(entries) { entry in
            Button {
              encodingScreenIsPresented = true
              encodingEntry = entry
            } label: {
              Image(uiImage: entry.uiImage).resizable().scaledToFit()
            }
          }
        }
      }
    }.sheet(isPresented: $encodingScreenIsPresented) {
      VStack {
        if (encodingProgress == 0.0) {
          ZStack {
            Image(uiImage: encodingEntry.uiImage).resizable().scaledToFit()
          }.padding()
        } else {
          ZStack {
            Image(uiImage: encodingEntry.uiImage).resizable().scaledToFit().brightness(-0.3)
            ProgressView().scaleEffect(x: 5, y: 5, anchor: .center)
          }.padding()
        }
        HStack {
          Button {
            encodingProgress = 0.5
          } label: {
            Text("Encode")
          }.buttonStyle(.borderedProminent)
          Button {
            encodingProgress = 0.7
          } label: {
            Text("Copy")
          }.buttonStyle(.borderedProminent)
          Button {
            encodingProgress = 0.0
          } label: {
            Text("Cancel")
          }.buttonStyle(.borderedProminent)
        }.padding()
        ProgressView(value: encodingProgress).padding()
      }
    }
  }
}

#Preview {
  let uiImage = UIImage(named: "AppIcon")!

  let entries = (0..<14).map {
    RecordedVideoEntry(url: URL(fileURLWithPath: "\($0).mkv"), uiImage: uiImage)
  }

  return ContentView(entries: entries)
}

  /*
  let paths = RecoreonPaths()
  let thumbnailExtrator = ThumbnailExtractor()
  let videoEncoder = VideoEncoder()

  func listVideoEntries() -> [VideoEntry] {
    paths.ensureRecordsDirExists()
    paths.ensureThumbnailsDirExists()
    var entries: [VideoEntry] = []
    for url in paths.listMkvRecordURLs() {
      guard let thumbURL = paths.getThumbnailURL(videoURL: url) else { continue }
      print(thumbURL)
      if !FileManager.default.fileExists(atPath: thumbURL.path()) {
        thumbnailExtrator.extract(url, thumbnailURL: thumbURL)
      }
      guard let uiImage = UIImage(contentsOfFile: thumbURL.path()) else { continue }
      guard let cgImage = uiImage.cgImage else { continue }
      var cropped: CGImage?
      if cgImage.width > cgImage.height {
        let xPos = (cgImage.width - cgImage.height) / 2
        cropped = cgImage.cropping(
          to: CGRect(x: xPos, y: 0, width: cgImage.height, height: cgImage.height))
      } else {
        let yPos = (cgImage.height - cgImage.width) / 2
        cropped = cgImage.cropping(
          to: CGRect(x: 0, y: yPos, width: cgImage.width, height: cgImage.width))
      }
      entries.append(
        VideoEntry(id: url.lastPathComponent, url: url, uiImage: UIImage(cgImage: cropped!)))
    }
    return entries
  }

  @State var encodingProgress: Double = 0.0
  @State var videoEntries: [VideoEntry] = []
  @State var showingEncodeCompletedAlert = false

  var body: some View {
    VStack {
      Text("Encoding progress")
      ProgressView(value: encodingProgress)
      List {
        ForEach(videoEntries, id: \.id) { entry in
          Button {
            Task {
              paths.ensureEncodedVideosDirExists()
              try? FileManager.default.copyItem(
                atPath: entry.url.path(),
                toPath: NSHomeDirectory() + "/Documents/" + entry.url.lastPathComponent)
              let outputURL = paths.getEncodedVideoURL(videoURL: entry.url, suffix: "discord")!
              let isSuccessful = await videoEncoder.encode(
                entry.url, outputURL: outputURL,
                progressHandler: { progress in
                  Task { @MainActor in
                    encodingProgress = min(progress, 1.0)
                  }
                })
              if isSuccessful {
                UISaveVideoAtPathToSavedPhotosAlbum(outputURL.path(), nil, nil, nil)
                showingEncodeCompletedAlert = true
              } else {

              }
            }
          } label: {
            Image(uiImage: entry.uiImage).resizable().scaledToFit()
          }.alert(
            "Encoding completed", isPresented: $showingEncodeCompletedAlert,
            actions: {
              Button("OK") {}
            })
        }
      }.onAppear {
        /*if (videoEntries == nil) {
          videoEntries = listVideoEntries()
        }*/
      }
    }
  }
}*/
