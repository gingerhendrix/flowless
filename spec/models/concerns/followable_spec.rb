require 'spec_helper'

describe Followable do
  let(:test_class) { Class.new { include Followable, Mongoid::Document } }

  context 'scope' do
    describe 'followed_by, remindable_for_follower' do
      it { test_class.should respond_to :followed_by }
      it { test_class.should respond_to :remindable_for_follower }
    end
  end
end