import React, { useEffect } from 'react';
import { useSize } from 'react-use';

import chart from './cdfChartD3';

/**
 * @param min
 * @param max
 * @returns {number}
 */
function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

/**
 * @param props
 * @returns {*}
 * @constructor
 */
function CdfChart(props) {
  const id = "chart-" + getRandomInt(0, 100000);
  const scale = props.scale || 'linear';
  const style = !!props.width ? { width: props.width + "px" } : {};

  const [sized, { width }] = useSize(() => {
    return React.createElement("div", {
      key: "resizable-div",
    });
  }, {
    width: props.width,
  });

  useEffect(() => {
    chart()
      .svgWidth(width)
      .svgHeight(props.height)
      .maxX(props.maxX)
      .minX(props.minX)
      .onHover(props.onHover)
      .marginBottom(props.marginBottom || 15)
      .marginLeft(5)
      .marginRight(5)
      .marginTop(5)
      .showDistributionLines(props.showDistributionLines)
      .verticalLine(props.verticalLine)
      .showVerticalLine(props.showVerticalLine)
      .container("#" + id)
      .data({ primary: props.primaryDistribution })
      .scale(scale)
      .render();
  });

  return React.createElement("div", {
    style: {
      paddingLeft: "10px",
      paddingRight: "10px",
    },
  }, [
    sized,
    React.createElement("div", { id, style, key: id }),
  ]);
}

export default CdfChart;
