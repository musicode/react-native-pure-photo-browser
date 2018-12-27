import React, {
  Component,
} from 'react'

import {
  requireNativeComponent,
  ViewPropTypes,
} from 'react-native'

import PropTypes from 'prop-types'

class ThumbnailView extends Component {

  static propTypes = {
    uri: PropTypes.string.isRequired,
    width: PropTypes.number.isRequired,
    height: PropTypes.number.isRequired,
    borderRadius: PropTypes.number,
    style: ViewPropTypes.style,

    onLoadStart: PropTypes.func,
    onLoadProgress: PropTypes.func,
    onLoadEnd: PropTypes.func,
  }

  handleLoadStart = () => {
    let { onLoadStart } = this.props
    if (onLoadStart) {
      onLoadStart()
    }
  }

  handleLoadProgress = event => {
    let { onLoadProgress } = this.props
    if (onLoadProgress) {
      onLoadProgress(event.nativeEvent)
    }
  }

  handleLoadEnd = event => {
    let { onLoadEnd } = this.props
    if (onLoadEnd) {
      onLoadEnd(event.nativeEvent)
    }
  }

  render() {

    let {
      uri,
      width,
      height,
      borderRadius,
      style,
    } = this.props

    let props = { uri, width, height }

    if (borderRadius != null) {
      props.borderRadius = borderRadius
    }

    if (style != null) {
      props.style = [
        style,
        { width, height }
      ]
    }
    else {
      props.style = { width, height }
    }

    return (
      <RNTThumbnailView
        {...props}
        onThumbnailLoadStart={this.handleLoadStart}
        onThumbnailLoadProgress={this.handleLoadProgress}
        onThumbnailLoadEnd={this.handleLoadEnd}
        onLoadStart={this.handleLoadStart}
        onLoadProgress={this.handleLoadProgress}
        onLoadEnd={this.handleLoadEnd}
      />
    )
  }

}

const RNTThumbnailView = requireNativeComponent('RNTThumbnailView', ThumbnailView)

export default ThumbnailView
