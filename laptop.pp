### <3 Creating A Lovely Ubuntu <3 ###


### PACKAGES!! :D ###
$development = [ 
                 "git",
                 "tig",
                 "emacs",
                 "vim",
                 "python-flake8",
                 "pep8",
                 "python-nose",
                 "python-pip",
                 "python-nosexcover",
                 "python-hamcrest",
                 "nodejs",
                 "npm",
                 "cmake",
                ]
package { $development: ensure => "installed" }

$desktop = [
             "gnupg",
             "tree",
             "chromium-browser",
             "aptitude",
             "synaptic",
             "keepassx",
             "gimp",
             "xchat",
            ]
package { $desktop: ensure => "installed" }


### SETTINGS!! :D ###
$home = '/home/mango'
$dotfiles = "$home/.dotfiles"
exec { "get_dotfiles":
     command => "/bin/bash -c \"cd $home && git clone https://github.com/perfa/dotfiles.git .dotfiles\"",
     creates => $dotfiles,
     }

file { $dotfiles: }

file { "$home/.gitconfig":
     ensure  => link,
     target  => "$dotfiles/.gitconfig",
     require => File[$dotfiles],
     }

file { "$home/.gitignore":
     ensure  => link,
     target  => "$dotfiles/.gitignore",
     require => File[$dotfiles],
     }

file { "$home/.emacs":
     ensure  => link,
     target  => "$dotfiles/.emacs",
     require => File[$dotfiles], }

file { "$home/.emacs.d":
     ensure  => link,
     target  => "$dotfiles/.emacs.d",
     require => File[$dotfiles],
     }
file { "$home/.vim":
     ensure  => link,
     target  => "$dotfiles/.vim",
     require => File[$dotfiles],
     }

file { "$home/.vimrc":
     ensure  => link,
     target  => "$dotfiles/.vimrc",
     require => File[$dotfiles],
     }

file { "$home/.bashrc.private":
     ensure  => link,
     target  => "$dotfiles/.bashrc.private",
     require => File[$dotfiles],
     }


### Thinkpad/Lenovo Power control (TLP) and UbuntuTweak ###
# These two need some special apt lovin', as they have their own PPA's
include apt

apt::source { 'linrunner_tlp':
    location    => 'http://ppa.launchpad.net/linrunner/tlp/ubuntu',
    repos       => 'main',
    include_src => true,
    key         => '02D65EFF',
    key_server  => 'keyserver.ubuntu.com',
    }

apt::source { 'ubuntu_tweak':
    location    => 'http://ppa.launchpad.net/tualatrix/ppa/ubuntu',
    repos       => 'main',
    include_src => false,
    key         => 'E260F5B0',
    key_server  => 'keyserver.ubuntu.com',
    }

$tlp_pkgs = [
             "tlp",
             "tlp-rdw",
             "tp-smapi-dkms",
             "acpi-call-tools",
            ]

package { $tlp_pkgs: 
     ensure  => installed,
     require => Apt::Source[linrunner_tlp],
     }

package { "ubuntu-tweak":
     ensure  => installed,
     require => Apt::Source[ubuntu_tweak],
     }


### LAUNCHER!!! :D ###
exec { "/usr/bin/gsettings set com.canonical.Unity.Launcher favorites \"${unity_favorites}\"" :
     require => Package[$desktop],
     user => "mango",
}


### Fuck unity hidey-disappeary scrollbars!!!! :D ###
exec { "gsettings set com.canonical.desktop.interface scrollbar-mode normal":
}
