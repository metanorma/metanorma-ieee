module Metanorma
  module IEEE
    class TermLookupCleanup < Metanorma::Standoc::TermLookupCleanup
      def remove_missing_ref_term(node, _target)
        node.at("../xrefrender")&.remove
        node.replace("<preferred><name>#{node.children.to_xml}</name>"\
                     "</preferred>")
      end
    end
  end
end
