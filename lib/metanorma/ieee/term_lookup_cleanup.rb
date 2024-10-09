module Metanorma
  module Ieee
    class TermLookupCleanup < Metanorma::Standoc::TermLookupCleanup
      def remove_missing_ref_term(node, _target, type)
        type == "symbol" and return super
        node.at("../xrefrender")&.remove
        #node.replace("<preferred><expression><name>#{node.children.to_xml}"\
        #             "</name></expression></preferred>")
        node.replace("<refterm>#{node.children.to_xml}</refterm>")
      end
    end
  end
end
