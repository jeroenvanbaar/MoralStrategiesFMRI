% run this to load up CheckReg file selector; loading multiple images
% let's you play a video of them, simply by pressing a little play button
% 
% Guillaume Flandin (personal communication):
% Display one image with CheckReg then do a right click, choose
% "Browse..." and select all the images you want to display.
% Or type the following if you don't like this two-step approach:
%   spm_check_registration(spm_select(Inf,'image'))
% Note that there is also a contextual menu on some of the batch entries
% containing list of images that do the same thing - it's called 'Preview'.


spm_check_registration(spm_select(Inf,'image'))