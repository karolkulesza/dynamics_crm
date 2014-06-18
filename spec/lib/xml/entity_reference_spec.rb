require 'spec_helper'

describe DynamicsCRM::XML::EntityReference do

  describe 'initialization' do
    subject {
      DynamicsCRM::XML::EntityReference.new("opportunity", "9BF1325C-A592-E311-B7F3-6C3BE5A8A0C8")
    }

    context "default instance" do
      it { subject.logical_name.should == "opportunity" }
      it { subject.id.should == "9BF1325C-A592-E311-B7F3-6C3BE5A8A0C8" }
      it { subject.name.should be_nil }
    end

    context "#to_xml" do
      it "outputs entityReference with no namespace" do
        # Spacing here is intentional to match created string.
        expected_xml = %Q{
        <entityReference>
          <Id>9BF1325C-A592-E311-B7F3-6C3BE5A8A0C8</Id>
          <LogicalName>opportunity</LogicalName>
          <Name #{@name ? '' : 'nil="true"'}>#{@name}</Name>
        </entityReference>
        }
        subject.to_xml.should == expected_xml
      end

      it "outputs EntityReference with namespace" do
        # Spacing here is intentional to match created string.
        expected_xml = %Q{
        <b:EntityReference>
          <b:Id>9BF1325C-A592-E311-B7F3-6C3BE5A8A0C8</b:Id>
          <b:LogicalName>opportunity</b:LogicalName>
          <b:Name #{@name ? '' : 'nil="true"'}>#{@name}</b:Name>
        </b:EntityReference>
        }
        subject.to_xml(namespace: 'b', camel_case: true).should == expected_xml
      end

    end

    context "#from_xml" do
      let(:subject) {
        xml = REXML::Document.new(%Q{<entityReference>
            <LogicalName>opportunity</LogicalName>
            <Id>9BF1325C-A592-E311-B7F3-6C3BE5A8A0C8</Id>
            <Name>Sample Opportunity Name</Name>
          </entityReference>})
        DynamicsCRM::XML::EntityReference.from_xml(xml.root)
      }

      it { subject.logical_name.should == "opportunity" }
      it { subject.id.should == "9BF1325C-A592-E311-B7F3-6C3BE5A8A0C8" }
      it { subject.name.should == "Sample Opportunity Name" }
    end

  end

end
