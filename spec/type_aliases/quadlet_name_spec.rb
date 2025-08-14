# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Quadlet_name' do
  context 'with a permitted unit name' do
    [
      'centos.container',
      'fast.network',
      'empty.volume',
      'masive.pod',
      'special.kube',
      'impressive.image',
    ].each do |unit|
      it { is_expected.to allow_value(unit) }
    end
  end

  context 'with a illegal unit name' do
    [
      'a space.service',
      'noending',
      'wrong.ending',
      'forward/slash.unit',
    ].each do |unit|
      it { is_expected.not_to allow_value(unit) }
    end
  end
end
