/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

// NOTE!! Based on code taken from this webpage:
// https://www.raywenderlich.com/2392-cookbook-using-nsurlsession

import Foundation

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
@objc class DownloadService: NSObject {

    // SearchViewController creates downloadsSession
    @objc var downloadsSession: URLSession!
    var activeDownloads: [URL: Download] = [:]
    @objc var completionHandler: ((URL) -> Void)?

    // MARK: - Download methods called by ObjectToDownloadCell delegate methods

    @objc func startDownload(_ otd: ObjectToDownload) {
        // Create object
        let download = Download(otd: otd)
        // Add a download taskt with the URL
        download.task = downloadsSession.downloadTask(with: otd.refURL)
        // Start that task
        download.task!.resume()
        // Enable flag
        download.isDownloading = true
        // Add it to the dictionary of activeDownloads
        activeDownloads[download.otd.refURL] = download
    }

    func pauseDownload(_ otd: ObjectToDownload) {
    guard let download = activeDownloads[otd.refURL] else { return }
    if download.isDownloading {
        download.task?.cancel(byProducingResumeData: { data in
            download.resumeData = data
        })
        download.isDownloading = false
    }
    }

    func cancelDownload(_ otd: ObjectToDownload) {
        if let download = activeDownloads[otd.refURL] {
            download.task?.cancel()
            activeDownloads[otd.refURL] = nil
        }
    }

    func resumeDownload(_ otd: ObjectToDownload) {
        guard let download = activeDownloads[otd.refURL] else { return }
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadsSession.downloadTask(with: download.otd.refURL)
        }
        
        download.task!.resume()
        download.isDownloading = true
    }
}

@objc extension DownloadService: URLSessionDownloadDelegate
{
    // Stores downloaded file
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        guard let sourceURL = downloadTask.originalRequest?.url else
        {
            return
        }
        
        activeDownloads[sourceURL] = nil
        
        completionHandler?(location)
    }
}
