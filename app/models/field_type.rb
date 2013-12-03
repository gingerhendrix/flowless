# FieldType is a sort of interface / abstraction class to define what sort of method a FieldType should have
# but still prevent its direct instanciations
#
# @author Alex
#
# @attr_reader [ Object ] object a pricable object
# @attr_reader [ Ability ] ability an ability where reference pricing is stored
#
# @example Calculate cost per word for given priceable object and on given ability
#   ServiceObjects::OptionsSet::Price.new(object, ability).cost_per_word
#
# @example Calculate revenue per word for given author, on priceable object and on given ability
#   ServiceObjects::OptionsSet::Price.new(object, ability).revenue_per_word_for(author)
module FieldType

  DATA_TYPES = %i( boolean numerical string time array id )

end