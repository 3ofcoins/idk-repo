name 'production'
description 'Production environment (projectx.analyticsfire.com)'

default_attributes(
  af: {
    databackend: {
      domain: 'projectx.analyticsfire.com',
      secrets: {
        mixpanel_token: '509fb01286b219ceaa9ef24a41adc19c'
      }}})
