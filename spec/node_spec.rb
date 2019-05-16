require "node"

describe Node do
  describe "initialization" do
    context "given a simple node" do
      let(:node) {
        Node.new({
          'identifier' => 'foobar',
          'class' => 'Controller',
          'classNames' => ['class1', 'class2'],
          'size' => 5,
          'weirdProp' => 'strange',
          'coolProp' => 'ice',
        })
      }

      it "initializes properties correctly" do
        expect(node.identifier).to eq('foobar')
        expect(node.view_class).to eq('Controller')
        expect(node.class_names).to include('class1')
        expect(node.class_names).to include('class2')
        expect(node.properties['size']).to eq(5)
        expect(node.properties['coolProp']).to eq('ice')
      end
    end

    context "given a node with a child prop" do
      let(:node) {
        Node.new({
          'identifier' => 'foobar',
          'class' => 'Controller',
          'classNames' => ['class1', 'class2'],
          'size' => 5,
          'weirdProp' => 'strange',
          'coolProp' => 'ice',
          'childProp' => {
            'text' => 'some text'
          }
        })
      }

      it "creates the proper children" do
        expect(node.children.length).to eq(1)
        expect(node.children[0].properties['text']).to eq('some text')
      end
    end

    context "given a node with a child prop and an array of children" do
      let(:node) {
        Node.new({
          'identifier' => 'foobar',
          'class' => 'Controller',
          'classNames' => ['class1', 'class2'],
          'size' => 5,
          'weirdProp' => 'strange',
          'coolProp' => 'ice',
          'childProp' => {
            'text' => 'some text'
          },
          'someChildren' => [
            {'text' => 'hello'},
            {'identifier' => 'subchild'}
          ]
        })
      }

      it "creates the proper children" do
        expect(node.children.length).to eq(3)

        children_with_id = node.children.select { |c|
          c.identifier == 'subchild'
        }

        expect(children_with_id.length).to eq(1)
      end
    end
  end
end
