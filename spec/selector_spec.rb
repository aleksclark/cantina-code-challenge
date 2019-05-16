require "selector"
require "node"

describe Selector do

  describe "parsing" do
    context "given a plain view class" do
      let(:selector) { Selector.new('MyName') }

      it "populates the view class" do
        expect(selector.view_class).to eq('MyName')
      end

      it "doesn't populate anything else" do
        expect(selector.identifier).to be_nil
        expect(selector.class_names.length).to eq(0)
        expect(selector.properties.keys.length).to eq(0)
      end
    end

    context "given view class and identifier" do
      let(:selector) { Selector.new('MyName#foobar') }

      it "populates the view class and identifier" do
        expect(selector.view_class).to eq('MyName')
        expect(selector.identifier).to eq('foobar')
      end

      it "doesn't populate anything else" do
        expect(selector.class_names.length).to eq(0)
        expect(selector.properties.keys.length).to eq(0)
      end
    end

    context "given class names and properties" do
      let(:selector) { Selector.new('.class1.class2[prop1=1][prop2=baz][prop3=true][prop4=false][prop5=0.33]') }

      it "parses properties correctly" do
        expect(selector.properties['prop1']).to eq(1)
        expect(selector.properties['prop2']).to eq('baz')
        expect(selector.properties['prop3']).to be true
        expect(selector.properties['prop4']).to be false
        expect(selector.properties['prop5']).to eq(0.33)
      end

      it "parses classes correctly" do
        expect(selector.class_names).to include('class1')
        expect(selector.class_names).to include('class2')
      end

      it "doesn't populate anything else" do
        expect(selector.identifier).to be nil
        expect(selector.view_class).to be nil
      end
    end

  end


  describe "matching" do
    let(:node1) {
      Node.new({
        'identifier' => 'foobar',
        'class' => 'Controller',
        'classNames' => ['class1', 'class2'],
        'size' => 5,
        'weirdProp' => 'strange',
        'coolProp' => 'ice',
      })
    }

    let(:node2) {
      Node.new({
        'identifier' => 'baz',
        'class' => 'Input',
        'classNames' => [ 'class2'],
        'size' => 5,
      })
    }
    context "Given just a view class" do
      let(:selector) { Selector.new('Controller')}

      it "identifies a matching node" do
        expect(selector.matches?(node1)).to be true
      end

      it "doesn't cause a false positive" do
        expect(selector.matches?(node2)).to be false
      end
    end

    context "Given a class name" do
      let(:selector) { Selector.new('.class2')}

      it "identifies the matching nodes" do
        expect(selector.matches?(node1)).to be true
        expect(selector.matches?(node2)).to be true
      end
    end

    context "Given a class name and view class" do
      let(:selector) { Selector.new('Controller.class2')}

      it "identifies the matching nodes" do
        expect(selector.matches?(node1)).to be true
        expect(selector.matches?(node2)).to be false
      end
    end

    context "Given a class name and identifier" do
      let(:selector) { Selector.new('Controller#baz')}

      it "identifies the matching nodes" do
        expect(selector.matches?(node1)).to be false
        expect(selector.matches?(node2)).to be false
      end
    end

    context "Given some props and class names" do
      let(:selector) { Selector.new('.class2[weirdProp=strange]')}

      it "identifies the matching nodes" do
        expect(selector.matches?(node1)).to be true
        expect(selector.matches?(node2)).to be false
      end
    end

  end


end
