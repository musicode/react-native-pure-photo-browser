
import { NativeModules } from 'react-native'

const { RNTPhotoBrowser } = NativeModules

import PhotoBrowser from './js/PhotoBrowser'
import ThumbnailView from './js/ThumbnailView'

function saveLocalPhoto(path) {
  return RNTPhotoBrowser.saveLocalPhoto(path)
}

export {
  saveLocalPhoto,
  PhotoBrowser,
  ThumbnailView,
}
