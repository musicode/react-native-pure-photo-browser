import React, {
  Component,
} from 'react'

import ReactNative, {
  UIManager,
  requireNativeComponent,
  ViewPropTypes,
  NativeModules,
  Platform,
} from 'react-native'

import PropTypes from 'prop-types'

const { RNTPhotoBrowserManager } = NativeModules

const isIOS = Platform.OS === 'ios'

class PhotoBrowser extends Component {

  static propTypes = {
    list: PropTypes.array.isRequired,
    index: PropTypes.number.isRequired,
    indicator: PropTypes.number.isRequired,
    pageMargin: PropTypes.number.isRequired,

    style: ViewPropTypes.style,

    onTap: PropTypes.func,
    onLongPress: PropTypes.func,
    onSave: PropTypes.func,
    onChange: PropTypes.func,
    onDetectResult: PropTypes.func,
  }

  handleTap = event => {
    let { onTap } = this.props
    if (onTap) {
      onTap(event.nativeEvent)
    }
  }

  handleLongPress = event => {
    let { onLongPress } = this.props
    if (onLongPress) {
      onLongPress(event.nativeEvent)
    }
  }

  handleSave = event => {
    let { onSave } = this.props
    if (onSave) {
      onSave(event.nativeEvent)
    }
  }

  handleChange = event => {
    let { onChange } = this.props
    if (onChange) {
      onChange(event.nativeEvent)
    }
  }

  handleDetectResult = event => {
    let { onDetectResult } = this.props
    if (onDetectResult) {
      onDetectResult(event.nativeEvent)
    }
  }

  save() {
    if (isIOS) {
      RNTPhotoBrowserManager.save(this.getNativeNode())
    }
    else {
      UIManager.dispatchViewManagerCommand(
        this.getNativeNode(),
        UIManager.RNTPhotoBrowser.Commands.save,
        []
      )
    }
  }

  detect() {
    if (isIOS) {
      RNTPhotoBrowserManager.detect(this.getNativeNode())
    }
    else {
      UIManager.dispatchViewManagerCommand(
        this.getNativeNode(),
        UIManager.RNTPhotoBrowser.Commands.detect,
        []
      )
    }
  }

  getNativeNode() {
    return ReactNative.findNodeHandle(this.refs.photoBrowser);
  }

  render() {

    let {
      index,
      list,
      indicator,
      pageMargin,
      style,
    } = this.props

    return (
      <RNTPhotoBrowser
        ref="photoBrowser"
        index={index}
        list={list}
        indicator={indicator}
        pageMargin={pageMargin}
        style={style}
        onTap={this.handleTap}
        onLongPress={this.handleLongPress}
        onSave={this.handleSave}
        onChange={this.handleChange}
        onDetectResult={this.handleDetectResult}
      />
    )
  }

}

const RNTPhotoBrowser = requireNativeComponent('RNTPhotoBrowser', PhotoBrowser)

export default PhotoBrowser
