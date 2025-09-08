
if !has("python3")
  echo "vim has to be compiled with +python3 to run this"
  finish
endif

if exists('g:sample_python_plugin_loaded')
  finish
endif

let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

python3 << EOF
import sys
from os.path import normpath, join
import vim
plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '..', 'python'))
sys.path.insert(0, python_root_dir)
import sample

from pprint import pprint
EOF

let g:sample_python_plugin_loaded = 1

function! RunSavedCommand()
    python3 sample.run_async_command()
endfunction

function! MarkAndSaveTest()
python3 << EOF
full_path = sample.current_full_file_path()
test_class, test_method  = sample.file_test_method_and_class(full_path, sample.current_line_number())
test_command = sample.create_test_command(full_path, test_class, test_method)

sample.save_async_command(test_command, full_path)

EOF
endfunction

"python << EOF
"
"from sample import file_test_method_and_class, project_directory_parts
"import os.path.join
"filename = vim.eval('current_file')
"line_number = int(vim.eval('current_line'))
"class_name, method_name = find_method_and_class(filename, line_number)
"file_parts, local_parts, filename = project_directory_parts()
"file_name_without_extension = re.sub('\.py$', '', filename)
"base_name = os.path.join(local_parts, file_name_without_extension)
"
"unittest_cmd = 'python -m unittest ' . file_basename . '.' . class_name . '.' . method_name
"print( f'running {unittest_cmd }' )
"
"EOF


command! -nargs=0 MarkAndSaveTest call MarkAndSaveTest()
command! -nargs=0 RunSavedCommand call RunSavedCommand()

