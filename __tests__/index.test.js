import React from 'react'
import { shallow } from 'enzyme'
import Index from '../src/pages/index'

test('snapshot', () => {
  const component = shallow(<Index />)
  expect(component.find('h1').text()).toBe('Homepage')
})
