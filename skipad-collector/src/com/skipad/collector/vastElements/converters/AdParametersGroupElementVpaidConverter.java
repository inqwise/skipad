package com.skipad.collector.vastElements.converters;

import org.simpleframework.xml.convert.Converter;
import org.simpleframework.xml.stream.InputNode;
import org.simpleframework.xml.stream.Mode;
import org.simpleframework.xml.stream.OutputNode;

import com.skipad.collector.vastElements.AdParametersGroupElement;

public class AdParametersGroupElementVpaidConverter implements Converter<AdParametersGroupElement>{

	@Override
	public AdParametersGroupElement read(InputNode node) throws Exception {
		return null;
	}

	@Override
	public void write(OutputNode node, AdParametersGroupElement el)
			throws Exception {
		node.setMode(Mode.DATA);
		node.setValue(el.getText());
		node.setData(true);
	}
}