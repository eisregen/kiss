#
# written by Jakob Holderbaum
#
require 'rubygems'
require 'yaml'

$CONF = YAML::load File.open('config.yaml')

# environment
$EDITOR     = $CONF['system']['environment']['editor']

# pathes
$WEB_PATH       = $CONF['system']['pathes']['html']
$BLOCK_PATH     = $CONF['system']['pathes']['blocks']
$PAGE_PATH      = $CONF['system']['pathes']['pages']
$TPL_PATH       = $CONF['system']['pathes']['templates']

# files
$PAGE_ORDER_FILE    = $CONF['system']['files']['page_order'] 
$PAGE_ORDER_PATH    = File.join($PAGE_PATH,$PAGE_ORDER_FILE)

# postfixes
#$HTM_POSTFIX       = $CONF['system']['postfixes']['html']
$HTM_POSTFIX        = '.html' # the algorithms should cut srings dynamically, but's static yet
$BLOCK_POSTFIX      = $CONF['system']['postfixes']['block']
$PAGE_BLOCK_POSTFIX = $CONF['system']['postfixes']['page_block']
$PAGE_TITLE_POSTFIX = $CONF['system']['postfixes']['page_title']

# behaviour
$CHANGE_TITLE           = $CONF['behaviour']['chtitle']
if $CHANGE_TITLE
    $TITLE_SEPARATOR    = $CONF['behaviour']['separator']
end

# html - placeholders
$PHOLDER_TITLE            = $CONF['html']['placeholders']['title']
$PHOLDER_NAV            = $CONF['html']['placeholders']['navlist']
$PHOLDER_AUTHOR         = $CONF['html']['placeholders']['author']
$PHOLDER_DATE           = $CONF['html']['placeholders']['date']
$DATE_FORMAT            = $CONF['html']['placeholders']['dateformat']

# css - ids & classes
$NAV_ID                 = $CONF['html']['css_ids']['navlist']
$NAV_ELEM_UNSELECTED    = $CONF['html']['css_classes']['nav_elem_unsel']
$NAV_ELEM_SELECTED      = $CONF['html']['css_classes']['nav_elem_sel']

