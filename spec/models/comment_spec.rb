require 'spec_helper'

describe Comment do
  let(:comment) { FactoryGirl.build :comment }

  context 'building and validation' do
    describe 'standard comment' do
      it 'should build successfully and be valid' do
        expect(comment.valid?).to be_true
      end
    end
  end

  context 'public methods' do
    describe 'message' do
      let(:message_1) { FactoryGirl.build :message, content: '1' }
      let(:message_2) { FactoryGirl.build :message, content: '2' }

      before :each do
        comment.stub_chain(:messages, :versionned).and_return [ message_1, message_2 ]
      end

      it 'shoudl return the right message' do
        expect(comment.message).to be(message_1)
      end
    end

    describe 'content' do
      describe 'no messages present' do
        before :each do
          comment.stub(:message).and_return nil
        end

        it 'should not raise an error and return nil' do
          expect(comment.content).to be(nil)
        end
      end

      describe 'message is present' do
        let(:message) { FactoryGirl.build :message, content: 'ok' }

        before :each do
          comment.stub(:message).and_return message
        end

        it 'should return the right content' do
          expect(comment.content).to eq('ok')
        end
      end
    end
  end

  context 'private methods' do
  end
end


