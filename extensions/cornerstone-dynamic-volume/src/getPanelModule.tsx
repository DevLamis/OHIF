import React from 'react';
import { DynamicDataPanel } from './panels';
import { Toolbox } from '@ohif/ui';
import DynamicExport from './panels/DynamicExport';

function getPanelModule({ commandsManager, extensionManager, servicesManager }) {
  const wrappedDynamicDataPanel = ({ renderHeader, getCloseIcon, tab }) => {
    return (
      <DynamicDataPanel
        commandsManager={commandsManager}
        servicesManager={servicesManager}
        extensionManager={extensionManager}
        renderHeader={renderHeader}
        getCloseIcon={getCloseIcon}
        tab={tab}
      />
    );
  };

  const wrappedDynamicToolbox = ({ renderHeader, getCloseIcon, tab }) => {
    return (
      <>
        <Toolbox
          commandsManager={commandsManager}
          servicesManager={servicesManager}
          extensionManager={extensionManager}
          buttonSectionId="dynamic-toolbox"
          title="Threshold Tools"
          renderHeader={renderHeader}
          getCloseIcon={getCloseIcon}
          tab={tab}
        />
      </>
    );
  };

  const wrappedDynamicExport = () => {
    return (
      <>
        <DynamicExport
          commandsManager={commandsManager}
          servicesManager={servicesManager}
          extensionManager={extensionManager}
        />
      </>
    );
  };

  return [
    {
      name: 'dynamic-volume',
      iconName: 'tab-4d',
      iconLabel: '4D Workflow',
      label: '4D Workflow',
      component: wrappedDynamicDataPanel,
    },
    {
      name: 'dynamic-toolbox',
      iconName: 'tab-4d',
      iconLabel: '4D Workflow',
      label: 'Dynamic Toolbox',
      component: wrappedDynamicToolbox,
    },
    {
      name: 'dynamic-export',
      iconName: 'tab-4d',
      iconLabel: '4D Workflow',
      label: '4D Workflow',
      component: wrappedDynamicExport,
    },
  ];
}

export default getPanelModule;
