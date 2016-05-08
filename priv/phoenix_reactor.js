import React from 'react'
import ReactDOM from 'react-dom'

const instantiateComponent = (container) => {
  const componentName = container.getAttribute('data-react-component')
  const reactClass = window.reactComponents && window.reactComponents[componentName]
  if (reactClass != null) {
    const propsJson = container.getAttribute('data-react-props')
    const propsObject = JSON.parse(propsJson)
    const reactElement = React.createElement(reactClass, propsObject)
    ReactDOM.render(reactElement, container)
  } else {
    console.error(
      `Component "${componentName}" not exported.`,
      'Use "exportComponent" function from phoenix_reactor module.')
  }
}

const instantiateComponentAll = () => {
  const containers = document.querySelectorAll('[data-react-component]')
  for(let i = 0; i < containers.length; i++){
    instantiateComponent(containers[i])
  }
}

document.addEventListener('DOMContentLoaded', () => {
  instantiateComponentAll()
}, false)

export function exportComponent(componentName, component) {
  window.reactComponents = window.reactComponents || {}
  window.reactComponents[componentName] = component
}
